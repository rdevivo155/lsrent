import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ls_rent/constants/api.dart';
import 'package:ls_rent/model/response/login_response.dart';
import 'package:ls_rent/services/shared.dart';
import 'package:ls_rent/services/network.dart' as network;

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child:
                    // const Text(
                    //   'LS RENT',
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.w500,
                    //       fontSize: 30,
                    //       color: Colors.white),
                    // )
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 70, 20, 20),
                        child: Image.asset('assets/logo.png'))),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 150, 20, 20),
              child: TextField(
                controller: nameController,
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
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                autofocus: false,
                autocorrect: false,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
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
                          LoginResponse loginResponse = loginAuth(
                                  nameController.text, passwordController.text)
                              .then((value) {
                            Navigator.of(context).popAndPushNamed('/home');
                          }) as LoginResponse;
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
                  onPressed: () {},
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

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

Future<LoginResponse?> loginAuth(String username, String password) async {
  bool isOnline = await hasNetwork();
  if (isOnline) {
    final response =
        await http.post(Uri.parse(API.login), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'username': username,
      'password': password
    });

    if (response.statusCode == 200) {
      if (response.body.contains('result')) {
        LoginResponse loginResponse = response as LoginResponse;

        setBasicAuth(loginResponse.accessToken ?? "");
        setIsLogged(true);
        return loginResponse;
      } else {
        // Error error = Error.fromJson(jsonDecode(response.body));
        // checkError(error.code);
        return null;
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
