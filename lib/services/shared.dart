import 'package:shared_preferences/shared_preferences.dart';

setBasicAuth(String basicAuth) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString('basicAuth', basicAuth);
}

Future<String?> getBasicAuth() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('basicAuth');
}

removeBasicAuth() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('basicAuth');
}

setIsLogged(bool logged) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setBool('isLogged', logged);
}

Future<bool> getIsLogged() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLogged') ?? false;
}
