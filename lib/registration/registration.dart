import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../model/request/registration_request.dart';
import '../model/response/registration_response.dart';
import '../constants/constants.dart';

final emailFormKey = GlobalKey<FormState>(debugLabel: "username");
final passwordFormKey = GlobalKey<FormState>(debugLabel: "password");
final fiscalCodeFormKey = GlobalKey<FormState>(debugLabel: "fiscalCode");
final confirmPasswordFormKey =
    GlobalKey<FormState>(debugLabel: "ConfirmPassword");

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class Registration extends StatelessWidget {
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
              title: const Text('Registrati'),
            ),
            body: MyStatefulWidget(),
            backgroundColor: Color(0xff569CDD)));
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController fiscalCodeController = TextEditingController();

  TextStyle? labelStyle;
  bool loading = false;
  bool error = false;
  bool _obscureText = true;
  bool _obscureCopyPassText = true;

  @override
  void initState() {
    super.initState();
    nameController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
    fiscalCodeController.text = "";
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleCopyPass() {
    setState(() {
      _obscureCopyPassText = !_obscureCopyPassText;
    });
  }

  validateFields() {
    final e = emailFormKey.currentState?.validate();
    final p = passwordFormKey.currentState?.validate();
    final cp = confirmPasswordFormKey.currentState?.validate();
    //final f = fiscalCodeFormKey.currentState?.validate();

    if (p == true &&
        cp == true &&
        e == true &&
        nameController.text != "" &&
        passwordController.text != "" &&
        confirmPasswordController.text != "") {
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
      final response = await http.post(Uri.parse(baseUrl + "/api/v1/register"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: {
            "username": username,
            "password": password,
            "tax_code": taxCode,
            "terms": "1"
          }).timeout(const Duration(seconds: 20));
      print(request.toJson());

      print(response.body);

      if (response.statusCode == 201) {
        loading = false;
        RegistrationResponse registrationResponse =
            RegistrationResponse.fromJson(jsonDecode(response.body));

        print(registrationResponse.toJson());
        AlertDialog(
          title: Text("Registrazione"),
          content: Text("La registrazione è stata effettuate con successo!"),
          actions: [
            ElevatedButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
        return registrationResponse;
      } else {
        loading = false;
        AlertDialog(
          title: Text("Attenzione"),
          content: Text("I dati inseriti sono errati!"),
          actions: [
            ElevatedButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
        // checkError(response.statusCode);
        return null;
      }
    } else {
      loading = false;
      // checkError(0);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String emailError = "Inserire l'email";
    final String passwordError = "Inserire la password";
    final String taxCodeError = "Inserire il codice fiscale";

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
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Image.asset(
                            'assets/logo1.png',
                            width: 120,
                            height: 60,
                          ))),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Form(
                      key: emailFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        controller: nameController,
                        cursorColor: Colors.white,
                        // validator: (value) {
                        //   if (value?.length == 8) {
                        //     Future.delayed(Duration.zero, () async {
                        //       setState(() {
                        //         error = true;
                        //       });
                        //     });

                        //     return "Inserire una password min 8 caratteri";
                        //   }
                        //   if (value == null || value.isEmpty) {
                        //     Future.delayed(Duration.zero, () async {
                        //       setState(() {
                        //         error = true;
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
                        //         error = true;
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
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: confirmPasswordFormKey,
                      child: TextFormField(
                        obscureText: _obscureCopyPassText ? true : false,
                        cursorColor: Colors.white,
                        controller: confirmPasswordController,
                        style: TextStyle(color: Colors.white),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     Future.delayed(Duration.zero, () async {
                        //       setState(() {
                        //         error = true;
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
                            onTap: _toggleCopyPass,
                            child: Icon(
                              _obscureCopyPassText
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
                          labelText: 'Conferma password',
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
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     Future.delayed(Duration.zero, () async {
                        //       setState(() {
                        //         error = true;
                        //       });
                        //     });

                        //     return taxCodeError;
                        //   }
                        //   return null;
                        // },
                        autofocus: false,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.0),
                          ),
                          focusColor: Colors.white,
                          prefixIcon:
                              Icon(Icons.account_box, color: Colors.white),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.0),
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
                                color: Colors.white,
                                fontWeight: FontWeight.w800)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: validateFields()
                                ? Color(0xfff4af49)
                                : Colors.blueGrey),
                        onPressed: (loading)
                            ? null
                            : () async {
                                print(nameController.text);
                                print(passwordController.text);
                                // network.
                                if (validateFields()) {
                                  if (passwordController.text !=
                                      confirmPasswordController.text) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Attenzione"),
                                            content: Text(
                                                "Le password non coincidono"),
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
                                  } else {
                                    loading = true;

                                    var registrationResponse =
                                        await registration(
                                            context,
                                            nameController.text,
                                            passwordController.text,
                                            fiscalCodeController.text);
                                    if (registrationResponse != null) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Attenzione"),
                                              content: Text(
                                                  "La registrazione è stata effettuate con successo!"),
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
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Attenzione"),
                                              content: Text(
                                                  "Verifica con il tuo superiore l'avvenuta registrazione."),
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
                                    }
                                  }
                                }
                              },
                      )),
                ],
              ));
  }
}
