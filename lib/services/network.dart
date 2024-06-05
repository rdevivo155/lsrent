import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ls_rent/constants/api.dart';
import 'dart:convert';
import 'package:ls_rent/constants/constants.dart';
import 'package:ls_rent/model/response/login_response.dart';
import 'package:ls_rent/services/shared.dart';

class NetworkService {
  // Creare una variabile privata statica per l'istanza singleton
  static final NetworkService _singleton = NetworkService._internal();

  // Factory constructor per restituire la stessa istanza
  factory NetworkService() {
    return _singleton;
  }

  // Costruttore privato
  NetworkService._internal();

  Future<dynamic> fetchData(
      String endpoint, String token, BuildContext context) async {
    return await _attemptFetchData(endpoint, token, context, retry: true);
  }

  Future<dynamic> _attemptFetchData(
      String endpoint, String token, BuildContext context,
      {bool retry = false}) async {
    try {
      var response = await http.get(
        Uri.parse(baseUrl + endpoint),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token"
        },
      ).timeout(const Duration(seconds: 20));
      print(response.request);
      print(token);

      switch (response.statusCode) {
        case 200:
          return jsonDecode(response.body);
        case 401:
          if (retry) {
            // Retry login logic here
            final newToken = await _retryLogin(context);
            if (newToken != null) {
              return await _attemptFetchData(endpoint, newToken, context,
                  retry: false);
            }
          }
          setIsLogged(false);
          removeBasicAuth();
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false);
          break;
        case 404:
          return jsonDecode(response.body);

        default:
          throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String?> _retryLogin(BuildContext context) async {
    var username = await getUsername();
    var password = await getPassword();
    try {
      final response = await http.post(Uri.parse(API.login),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: {
            'username': username,
            'password': password
          }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        LoginResponse loginResponse =
            LoginResponse.fromJson(jsonDecode(response.body));
        setBasicAuth(loginResponse.data?.accessToken ?? "");
        setEmployee(loginResponse.data?.employeeId ?? 0);
        setIsLogged(true);
        final newToken = await getBasicAuth();

        if (newToken != null) {
          // Optionally update the stored token if needed
          return newToken;
        }
      }
    } catch (e) {
      print('Login retry failed: $e');
    }
    return null;
  }
}
