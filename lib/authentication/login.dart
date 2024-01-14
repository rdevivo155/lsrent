import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ls_rent/constants/api.dart';
import 'package:ls_rent/constants/globals.dart';
import 'package:ls_rent/model/response/login_response.dart';
import 'package:ls_rent/services/shared.dart';
import 'package:ls_rent/services/network.dart' as network;
import '../constants/constants.dart';
import '../model/response/push_response.dart';

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
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            body: MyStatefulWidget(), backgroundColor: Color(0xff569CDD)));
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextStyle? labelStyle;
  bool loading = false;
  bool errorEmail = false;
  bool errorPassword = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    loading = false;
    nameController.text = "";
    passwordController.text = "";
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  validateFields() {
    if (nameController.text != "" && passwordController.text != "") {
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

  Future<PushResponse?> checkToken(accessToken) async {
    final responsePush = await http.get(
      Uri.parse(baseUrl + "/api/v1/push/me"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': "Bearer ${accessToken}"
      },
    );

    print(responsePush.body);
    if (responsePush.statusCode == 200) {
      PushResponse response =
          PushResponse.fromJson(jsonDecode(responsePush.body));
      return response;
    }
    return null;
  }

  Future<PushResponse?> createToken(accessToken, id) async {
    final responsePush = await http
        .post(Uri.parse(baseUrl + "/api/v1/push"), headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': "Bearer ${accessToken}"
    }, body: {
      'id_user': id.toString(),
      'token': token
    });

    print(responsePush.body);

    if (responsePush.statusCode == 201) {
      setState(() {
        loading = false;
      });
      Navigator.of(context).popAndPushNamed('/home');
    }
  }

  Future<PushResponse?> updateToken(accessToken, id, pushID) async {
    final responsePush = await http.put(
        Uri.parse(baseUrl + "/api/v1/push/${pushID}"),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': "Bearer ${accessToken}"
        },
        body: {
          'id_user': id.toString(),
          'token': token
        });

    print(responsePush.body);

    if (responsePush.statusCode == 202) {
      setState(() {
        loading = false;
      });
      Navigator.of(context).popAndPushNamed('/home');
    }
  }

  Future<LoginResponse?> loginAuth(
      BuildContext context, String username, String password) async {
    bool isOnline = await hasNetwork();
    if (isOnline) {
      final response = await http.post(Uri.parse(baseUrl + "/api/v1/login"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: {
            'username': username.trim(),
            'password': password.trim()
          });

      print(response.body);

      if (response.statusCode == 200) {
        LoginResponse loginResponse =
            LoginResponse.fromJson(jsonDecode(response.body));
        print(loginResponse.toJson());
        setBasicAuth(loginResponse.data?.accessToken ?? "");
        setEmployee(loginResponse.data?.employeeId.toString() ?? "");
        setIsLogged(true);

        PushResponse? pushResponse =
            await checkToken(loginResponse.data?.accessToken);
        if (pushResponse != null) {
          if (pushResponse.data!.isEmpty) {
            await createToken(loginResponse.data?.accessToken,
                loginResponse.data?.employeeId);
          }
          if (pushResponse.data?.first.token != token) {
            await updateToken(loginResponse.data?.accessToken,
                loginResponse.data?.employeeId, pushResponse.data?.first.id);
          }
        }
      } else {
        //checkError(response.statusCode);
        setState(() {
          loading = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Attenzione"),
                content: Text("L'email o la password sono errate"),
                actions: [
                  ElevatedButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });

        return null;
      }
    } else {
      setState(() {
        loading = false;
      }); // checkError(0);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Attenzione"),
              content: Text("Assenza di rete"),
              actions: [
                ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String emailError = "Inserire un'email valida";
    final String passwordError = "Inserire la password";

    return Padding(
        padding: const EdgeInsets.all(10),
        child: loading
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3.5,
                    )))
            : ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                          child: Image.asset(
                            'assets/logo1.png',
                            width: 150,
                            height: 100,
                          ))),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Form(
                      key: emailFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        controller: nameController,
                        cursorColor: Colors.white,
                        // validator: (value) {
                        //   String pattern =
                        //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        //   RegExp regex = RegExp(pattern);

                        //   if (value != null &&
                        //       !regex.hasMatch(value)) {
                        //     Future.delayed(Duration(milliseconds: 4000),
                        //         () async {
                        //       setState(() {
                        //         errorEmail = true;
                        //       });
                        //     });

                        //     return emailError;
                        //   }
                        //   return null;
                        // },
                        autocorrect: false,
                        enableSuggestions: false,
                        autofocus: false,
                        style: TextStyle(color: Colors.white),
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.0),
                          ),
                          focusColor: Colors.white,
                          prefixIcon: Icon(Icons.account_circle_rounded,
                              color: Colors.white),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.0),
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
                        obscureText: _obscureText ? true : false,
                        cursorColor: Colors.white,
                        controller: passwordController,
                        style: TextStyle(color: Colors.white),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     Future.delayed(Duration.zero, () async {
                        //       setState(() {
                        //         errorPassword = true;
                        //       });
                        //     });

                        //     return passwordError;
                        //   }
                        //   return null;
                        // },
                        autofocus: false,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.0),
                          ),
                          focusColor: Colors.white,
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          suffixIcon: InkWell(
                            onTap: _toggle,
                            child: Icon(
                              _obscureText
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye_sharp,
                              size: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.0),
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
                                color: Colors.white,
                                fontWeight: FontWeight.w800)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: validateFields()
                              ? Color(0xfff4af49)
                              : Colors.blueGrey,
                          splashFactory:
                              !validateFields() ? NoSplash.splashFactory : null,
                        ),
                        onPressed: (loading)
                            ? null
                            : () async {
                                print(nameController.text);
                                print(passwordController.text);
                                // network.
                                if (validateFields()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  loginAuth(context, nameController.text,
                                      passwordController.text);
                                }
                                return null;

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
                                color: Colors.white,
                                fontWeight: FontWeight.w800)),
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff569CDD),
                            side: BorderSide(width: 1.0, color: Colors.white)),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/registration');
                        },
                      )),
                  SizedBox(height: 20),
                  Center(
                    child: Text('v1.0.1',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.w200)),
                  )
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
