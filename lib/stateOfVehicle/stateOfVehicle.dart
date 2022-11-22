import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ls_rent/authentication/login.dart';
import 'package:ls_rent/model/request/state_of_vehicle_request.dart';
import 'package:video_player/video_player.dart';

import '../model/response/state_of_vehicle_response.dart';
import '../services/shared.dart';
import '../constants/constants.dart';

final titleFormKey = GlobalKey<FormState>(debugLabel: "title");
final descriptionFormKey = GlobalKey<FormState>(debugLabel: "description");

class StateOfVehicle extends StatefulWidget {
  const StateOfVehicle({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<StateOfVehicle> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<StateOfVehicle> {
  File? image;
  bool loading = false;
  bool error = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickPhoto() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Stato del veicolo"),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Form(
                  key: titleFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      focusColor: Colors.black,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0),
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1.0),
                        ),
                        focusColor: Colors.black,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1.0),
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
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    pickImage();
                  }),
              MaterialButton(
                  color: Colors.blue,
                  child: const Text("Scatta una foto",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    pickPhoto();
                  }),
              SizedBox(
                height: 30,
              ),
              image != null
                  ? Image.file(image!, width: 200, height: 200)
                  : Text("Nessuna immagine selezionata"),
              Container(
                  height: 80,
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: ElevatedButton(
                    child: const Text('INVIA',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                    style: ElevatedButton.styleFrom(primary: Color(0xfff4af49)),
                    onPressed: (loading)
                        ? null
                        : () async {
                            statusOfVehicleRegistration(
                                context,
                                titleController.text,
                                descriptionController.text,
                                image!);
                          },
                  )),
            ],
          ),
        ));
  }
}

Future<StatusOfVehicleResponse?> statusOfVehicleRegistration(
    BuildContext context, String title, String description, File image) async {
  // bool isOnline = await hasNetwork();
  bool isOnline = true;
  // StatusOfVehicleRequest request = StatusOfVehicleRequest(
  //     pictureId: "string",
  //     title: title,
  //     description: description,
  //     vehicleId: 0,
  //     officeLocationId: 0,
  //     employeeId: 0);
  if (isOnline) {
    final authToken = await getBasicAuth();
    final vehicleId = await getVehicle();
    final officeLocationId = await getLocation();
    final employeeId = await getEmployee();
    print(vehicleId);
    print(officeLocationId);
    print(employeeId);

    final response = await http.post(
        Uri.parse(baseUrl + "/api/v1/vehicle-conditions"),
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
          StatusOfVehicleResponse.fromJson(jsonDecode(response.body));

      print(statusOfVehicleResponse.toJson());

      // Navigator.of(context).popAndPushNamed('/login');
      var headers = {'Authorization': "Bearer " + authToken};
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              baseUrl + '/api/v1/vehicle-conditions/${statusOfVehicleResponse.data?.id ?? ""}/upload-image'));
      request.files
          .add(await http.MultipartFile.fromPath('picture', image.path));
      request.headers.addAll(headers);

      http.StreamedResponse responseImage = await request.send();

      if (responseImage.statusCode == 202) {
        print(await responseImage.stream.bytesToString());
        return statusOfVehicleResponse;
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
