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

setUsername(String username) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString('username', username);
}

Future<String?> getUsername() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

removeUsername() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('username');
}

setPassword(String password) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString('password', password);
}

Future<String?> getPassword() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('password');
}

removePassword() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('password');
}

setIsLogged(bool logged) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setBool('isLogged', logged);
}

Future<bool> getIsLogged() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLogged') ?? false;
}

setVehicle(String vehicle) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString('vehicle', vehicle);
}

Future<String> getVehicle() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('vehicle') ?? "";
}

setLocation(String location) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString('location', location);
}

Future<String> getLocation() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('location') ?? "";
}

setEmployee(int employee) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setInt('employee', employee);
}

Future<int> getEmployee() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('employee') ?? 0;
}
