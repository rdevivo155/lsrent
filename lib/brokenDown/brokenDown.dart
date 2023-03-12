import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/constants.dart';

import '../model/response/state_of_vehicle_response.dart';
import '../services/shared.dart';

final titleFormKey = GlobalKey<FormState>(debugLabel: "title");
final descriptionFormKey = GlobalKey<FormState>(debugLabel: "description");

class BrokenDown extends StatefulWidget {
  const BrokenDown({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<BrokenDown> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BrokenDown> {
  File? imageToSend;
  bool loading = false;
  bool error = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.imageToSend = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<StatusOfVehicleResponse?> statusOfVehicleRegistration(
      BuildContext context,
      String title,
      String description,
      File image) async {
    // bool isOnline = await hasNetwork();
    bool isOnline = true;
    if (isOnline) {
      final authToken = await getBasicAuth();
      final vehicleId = await getVehicle();
      final officeLocationId = await getLocation();
      final employeeId = await getEmployee();
      print(vehicleId);
      print(officeLocationId);
      print(employeeId);

      final response = await http.post(
          Uri.parse(baseUrl + "/api/v1/vehicle-accidents"),
          headers: <String, String>{
            'Authorization': "Bearer " + authToken!
          },
          body: {
            "picture_id": "string",
            "title": title,
            "description": description,
            "vehicle_id": vehicleId,
            "office_location_id": officeLocationId,
            "employee_id": employeeId
          });

      print(response.body);

      if (response.statusCode == 201) {
        print("ok");
        StatusOfVehicleResponse statusOfVehicleResponse =
            StatusOfVehicleResponse?.fromJson(jsonDecode(response.body));

        // Navigator.of(context).popAndPushNamed('/login');
        var headers = {'Authorization': "Bearer " + authToken};
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(baseUrl +
                '/api/v1/vehicle-accidents/${statusOfVehicleResponse.data?.id ?? ""}/upload-image'));
        request.files
            .add(await http.MultipartFile.fromPath('picture', image.path));
        request.headers.addAll(headers);

        http.StreamedResponse responseImage = await request.send();

        if (responseImage.statusCode == 202) {
          print(await responseImage.stream.bytesToString());

          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Info"),
                  content: Text("L'immagine è stata inviata con successo!"),
                  actions: [
                    ElevatedButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          titleController.text = "";
                          descriptionController.text = "";
                          imageToSend = null;
                          loading = false;
                        });
                      },
                    )
                  ],
                );
              });
        } else {
          print(responseImage.reasonPhrase);
        }
      } else {
        // checkError(response.statusCode);
        return null;
      }
    } else {
      // checkError(0);
      return null;
    }
  }

  Future pickPhoto() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.imageToSend = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Guasto"),
            ),
            body: Center(
              child: !loading
                  ? SingleChildScrollView(
                      child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                          child: Form(
                            key: titleFormKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              controller: titleController,
                              cursorColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  Future.delayed(Duration.zero, () async {
                                    setState(() {
                                      error = true;
                                    });
                                  });

                                  return "Inserire un titolo";
                                }
                                return null;
                              },
                              autocorrect: false,
                              enableSuggestions: false,
                              autofocus: false,
                              style: TextStyle(color: Colors.black),
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 1.0),
                                ),
                                focusColor: Colors.black,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 1.0),
                                ),
                                labelText: 'Titolo',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Form(
                              key: descriptionFormKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: TextFormField(
                                controller: descriptionController,
                                cursorColor: Colors.white,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    Future.delayed(Duration.zero, () async {
                                      setState(() {
                                        error = true;
                                      });
                                    });

                                    return "Inserire un titolo";
                                  }
                                  return null;
                                },
                                autocorrect: false,
                                enableSuggestions: false,
                                autofocus: false,
                                style: TextStyle(color: Colors.black),
                                textCapitalization: TextCapitalization.none,
                                decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  focusColor: Colors.black,
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  labelText: 'Descrizione',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Colors.blue,
                            child: const Text("Carica immagine dalla galleria",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              pickImage();
                            }),
                        MaterialButton(
                            color: Colors.blue,
                            child: const Text("Scatta una foto",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              pickPhoto();
                            }),
                        SizedBox(
                          height: 30,
                        ),
                        imageToSend != null
                            ? Image.file(imageToSend!, width: 200, height: 200)
                            : Text("Nessuna immagine selezionata"),
                        Container(
                            height: 80,
                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                            child: ElevatedButton(
                              child: const Text('INVIA',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800)),
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xfff4af49)),
                              onPressed: (loading)
                                  ? null
                                  : () async {
                                      if (titleController.text != "" &&
                                          descriptionController.text != "" &&
                                          imageToSend != null) {
                                        setState(() {
                                          loading = true;
                                        });
                                        await statusOfVehicleRegistration(
                                            context,
                                            titleController.text,
                                            descriptionController.text,
                                            imageToSend!);
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Attenzione"),
                                                content: Text(
                                                    "Compilare tutti i campi"),
                                                actions: [
                                                  ElevatedButton(
                                                    child: Text("Ok"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      }
                                    },
                            )),
                      ],
                    ))
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 3.5,
                          ))),
            )));
  }
}
