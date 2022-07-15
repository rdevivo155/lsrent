import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ls_rent/constants/api.dart';
import 'package:ls_rent/model/response/login_response.dart';
import 'package:ls_rent/services/shared.dart';
import 'package:ls_rent/services/network.dart' as network;

import '../model/request/registration_request.dart';
import '../model/response/registration_response.dart';

final emailFormKey = GlobalKey<FormState>(debugLabel: "username");
final passwordFormKey = GlobalKey<FormState>(debugLabel: "password");
final fiscalCodeFormKey = GlobalKey<FormState>(debugLabel: "fiscalCode");

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class Registration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registrati'),
        ),
        body: MyStatefulWidget(),
        backgroundColor: Color(0xff569CDD));
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fiscalCodeController = TextEditingController();

  TextStyle? labelStyle;
  bool loading = false;
  bool error = false;

  @override
  void initState() {
    super.initState();
    nameController.text = "";
    passwordController.text = "";
    fiscalCodeController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    final String emailError = "Inserire l'email";
    final String passwordError = "Inserire la password";

    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 70, 20, 20),
                    child: Image.asset('assets/logo.png'))),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
              child: Form(
                key: emailFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: nameController,
                  cursorColor: Colors.white,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      Future.delayed(Duration.zero, () async {
                        setState(() {
                          error = true;
                        });
                      });

                      return emailError;
                    }
                    return null;
                  },
                  autocorrect: false,
                  enableSuggestions: false,
                  autofocus: false,
                  style: TextStyle(color: Colors.white),
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusColor: Colors.white,
                    prefixIcon:
                        Icon(Icons.account_circle_rounded, color: Colors.white),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: passwordFormKey,
                child: TextFormField(
                  obscureText: true,
                  cursorColor: Colors.white,
                  controller: passwordController,
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      Future.delayed(Duration.zero, () async {
                        setState(() {
                          error = true;
                        });
                      });

                      return passwordError;
                    }
                    return null;
                  },
                  autofocus: false,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusColor: Colors.white,
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: fiscalCodeFormKey,
                child: TextFormField(
                  obscureText: false,
                  cursorColor: Colors.white,
                  controller: fiscalCodeController,
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      Future.delayed(Duration.zero, () async {
                        setState(() {
                          error = true;
                        });
                      });

                      return passwordError;
                    }
                    return null;
                  },
                  autofocus: false,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusColor: Colors.white,
                    prefixIcon: Icon(Icons.account_box, color: Colors.white),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                    labelText: 'Codice fiscale',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
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
                          print(nameController.text);
                          print(passwordController.text);
                          // network.
                          if (validateFields()) {
                            registration(
                                context,
                                nameController.text,
                                passwordController.text,
                                fiscalCodeController.text);
                          }

                          // loginAuth(
                          //         nameController.text, passwordController.text)
                          //     .then((value) {
                          //   if (value?.accessToken != "" &&
                          //       value?.accessToken != null) {
                          //     Navigator.of(context).popAndPushNamed('/home');
                          //   }
                          // });
                        },
                )),

            // Container(
            //     height: 80,
            //     padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            //     child: TextButton(
            //       child: const Text(
            //         'Password dimenticata',
            //         style: TextStyle(fontSize: 16, color: Colors.white),
            //       ),
            //       onPressed: () {
            //         //signup screen
            //       },
            //     ))
          ],
        ));
  }
}

validateFields() {
  final e = emailFormKey.currentState!.validate();
  final p = passwordFormKey.currentState!.validate();
  if (p == true && e == true) {
    return true;
  }
  return false;
}

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

Future<RegistrationResponse?> registration(BuildContext context,
    String username, String password, String taxCode) async {
  bool isOnline = await hasNetwork();
  RegistrationRequest request =
      RegistrationRequest(username, password, taxCode, 1);
  if (isOnline) {
    final response = await http.post(
        Uri.parse("https://api.lsrent.ml/api/v1/register"),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          "username": "prova@prova.it",
          "password": "Eg7fBAPsn2LET9",
          "tax_code": "CSRNGL75C22F839W",
          "terms": "1"
        });
    print(request.toJson());

    print(response.body);

    if (response.statusCode == 201) {
      RegistrationResponse registrationResponse =
          RegistrationResponse.fromJson(jsonDecode(response.body));

      print(registrationResponse.toJson());

      Navigator.of(context).popAndPushNamed('/login');

      return registrationResponse;
    } else {
      // checkError(response.statusCode);
      return null;
    }
  } else {
    // checkError(0);
    return null;
  }
}
