import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ls_rent/components/info_card.dart';
import 'package:http/http.dart' as http;
import 'package:ls_rent/services/response/profile_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';

import '../services/shared.dart';

ProfileResponse? profileResponse;

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidget();
}

class Profile extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profilo'),
        ),
        body: MyStatefulWidget(),
        backgroundColor: Color(0xff569CDD));
  }
}

class _MyStatefulWidget extends State<MyStatefulWidget> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> showCustomDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Attenzione'),
          content: const Text(
            'Se si sceglie di continuare verrà eliminato l\'account',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continua'),
            ),
          ],
        ),
      );

  Future downloadData() async {
    print("init");
    final id = await getEmployee();
    final authToken = await getBasicAuth();
    print(authToken);
    try {
      var response = await http.get(
          Uri.parse(baseUrl + "/api/v1/employees/" + id),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + (authToken ?? "")
          }).timeout((const Duration(seconds: 10)));

      log(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        profileResponse = ProfileResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401 || response.statusCode >= 500) {}
      return response;
    } on TimeoutException catch (_) {
      print("non funziona");
      // checkError(0, "Connessione assente!");
    } // return your response
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double marginPercentage = 5; // Modifica questa percentuale a tuo piacimento
    return FutureBuilder(
        future: downloadData(),
        builder: (context, projectSnap) {
          if (projectSnap.data != null) {
            return Scaffold(
                backgroundColor: Color(0xff569CDD),
                body: SafeArea(
                  minimum: EdgeInsets.only(
                      top: screenHeight * marginPercentage / 100),
                  child: Column(
                    children: <Widget>[
                      // CircleAvatar(
                      //   radius: 50,
                      //   backgroundImage: AssetImage('assets/avatar.jpg'),
                      // ),

                      Text(
                        profileResponse!.data!.lastName!,
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Pacifico",
                        ),
                      ),

                      Text(
                        profileResponse!.data!.firstName!,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            letterSpacing: 2.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Source Sans Pro"),
                      ),
                      SizedBox(
                        height: 20,
                        width: 200,
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),

                      // we will be creating a new widget name info carrd

                      InfoCard(
                          text: profileResponse!.data!.phone,
                          icon: Icons.phone,
                          onPressed: () async {}),
                      // InfoCard(
                      //     text: url, icon: Icons.web, onPressed: () async {}),
                      InfoCard(
                          text: profileResponse!.data!.city,
                          icon: Icons.location_city,
                          onPressed: () async {}),
                      InfoCard(
                          text: profileResponse!.data!.email,
                          icon: Icons.email,
                          onPressed: () async {}),
                      Container(
                          height: 80,
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                          child: ElevatedButton(
                            child: const Text('LOGOUT',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800)),
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xfff4af49)),
                            onPressed: () async {
                              setIsLogged(false);
                              removeBasicAuth();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login', (Route<dynamic> route) => false);
                            },
                          )),
                      Container(
                          height: 80,
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                          child: ElevatedButton(
                            child: const Text('ELIMINA ACCOUNT',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800)),
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 253, 12, 12)),
                            onPressed: () async {
                              showCustomDialog(context);
                            },
                          )),
                    ],
                  ),
                ));
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }
        });
  }
}
