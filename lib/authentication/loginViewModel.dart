import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ls_rent/model/response/login_response.dart';
import 'package:ls_rent/services/shared.dart';
import '../constants/constants.dart';

class LoginViewModel with ChangeNotifier {
  bool loading = false;
  bool _obscureText = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool get obscureText => _obscureText;

  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  bool validateFields() {
    return nameController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }

  Future<LoginResponse?> loginAuth(BuildContext context, Function(String, String) showDialogCallback) async {
  if (!validateFields()) return null;
  loading = true;
  notifyListeners();

  bool isOnline = await hasNetwork();
  if (!isOnline) {
    showDialogCallback("Attenzione", "Assenza di rete");
    loading = false;
    notifyListeners();
    return null;
  }

  try {
    final response = await http.post(
      Uri.parse(baseUrl + "/api/v1/guest/login"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'username': nameController.text.trim(),
        'password': passwordController.text.trim()
      }
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
      setBasicAuth(loginResponse.data?.accessToken ?? "");
      setEmployee(loginResponse.data?.employeeId.toString() ?? "");
      setIsLogged(true);

      loading = false;
      notifyListeners();
      Navigator.of(context).popAndPushNamed('/home');
    } else {
      showDialogCallback("Attenzione", "L'email o la password sono errate");
      loading = false;
      notifyListeners();
    }
  } catch (error) {
    showDialogCallback("Attenzione", "Errore di rete");
    print("Errore durante la richiesta HTTP: $error");
    loading = false;
    notifyListeners();
  }

  return null;
}

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            ElevatedButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }
}