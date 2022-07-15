import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ls_rent/constants/api.dart';
import 'package:ls_rent/model/response/login_response.dart';
import 'package:ls_rent/services/shared.dart';
import 'package:ls_rent/services/network.dart' as network;

final emailFormKey = GlobalKey<FormState>(debugLabel: "username");
final passwordFormKey = GlobalKey<FormState>(debugLabel: "password");

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MyStatefulWidget(), backgroundColor: Color(0xff569CDD));
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextStyle? labelStyle;
  bool loading = false;
  bool error = false;

  @override
  void initState() {
    super.initState();
    nameController.text = "";
    passwordController.text = "";
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
              padding: const EdgeInsets.fromLTRB(20, 150, 20, 20),
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
                height: 80,
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: ElevatedButton(
                  child: const Text('ACCEDI',
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
                            loginAuth(context, nameController.text,
                                passwordController.text);
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
            Container(
                height: 60,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: ElevatedButton(
                  child: const Text('REGISTRATI',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xff569CDD),
                      side: BorderSide(width: 1.0, color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/registration');
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

Future<LoginResponse?> loginAuth(
    BuildContext context, String username, String password) async {
  bool isOnline = await hasNetwork();
  if (isOnline) {
    final response = await http.post(
        Uri.parse("https://api.lsrent.ml/api/v1/login"),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'username': username,
          'password': password
        });

    print(response.body);

    if (response.statusCode == 200) {
      LoginResponse loginResponse =
          LoginResponse.fromJson(jsonDecode(response.body));

      print(loginResponse.toJson());
      setBasicAuth(loginResponse.data?.accessToken ?? "");
      setIsLogged(true);
      Navigator.of(context).popAndPushNamed('/home');

      return loginResponse;
    } else {
      // checkError(response.statusCode);
      return null;
    }
  } else {
    // checkError(0);
    return null;
  }
}
