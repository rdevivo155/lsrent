// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:ls_rent/services/shared.dart';

// class Generic {
//   static T fromJson<T>(T t, dynamic json) {
//     print(t.runtimeType);
//     // if (t.runtimeType == "Config") {
//     //   return Config.fromJson(json) as T;
//     // }
//     // if (T == GenericResponse) {
//     //return GenericResponse.fromJson(json) as T;
//     // } else {
//     //   throw Exception("Unknown class");
//     // }
//     // return {};
//     return t;
//   }
// }

// Network network = Network();

// class Network {
//   Future<Map<String, dynamic>> getRequest(
//       dynamic t, BuildContext? context) async {
//     final basicAuth = await getBasicAuth();
//     try {
//           throw Exception('Failed to load post');
//       }
//     } on TimeoutException catch (_) {
//       return {};
//       // print("non funziona");
//       // checkError(0, "Connessione assente!");
//     }
//   }
// }  final response = await http
//           .post(Uri.parse(API.api),
//               headers: <String, String>{
//                 'Content-Type': 'application/json; charset=UTF-8',
//                 'authorization': basicAuth ?? ""
//               },
//               body: jsonEncode(t))
//           .timeout((const Duration(seconds: 10)));
//       if (response.statusCode == 200) {
//         if (response.body.contains("result")) {
//           // globals.isError = false;
//           Map<String, dynamic> map = json.decode(response.body);
//           return map;
//         } else {
//           //Error error = Error.fromJson(jsonDecode(response.body));
//           // globals.isError = true;
//           // globals.errorMessage = checkError(error.code, error.message);
//           return {};
//         }
//       } else if (response.statusCode == 401) {
//         return {};
//         // Navigator.pushAndRemoveUntil(
//         //     context!,
//         //     SlideRightPageRoute(page: const LoginPage()),
//         //     (Route<dynamic> route) => false);
//       } else {
//         //showMessage(context!);
  
