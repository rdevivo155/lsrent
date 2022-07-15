class LoginResponse {
  int? statusCode;
  String? message;
  LoginData? data;

  LoginResponse({this.statusCode, this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  int? id;
  String? username;
  String? taxCode;
  String? accessToken;
  int? privilegeId;
  int? employeeId;

  LoginData(
      {this.id,
      this.username,
      this.taxCode,
      this.accessToken,
      this.privilegeId,
      this.employeeId});

  LoginData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    taxCode = json['tax_code'];
    accessToken = json['accessToken'];
    privilegeId = json['privilege_id'];
    employeeId = json['employee_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['tax_code'] = this.taxCode;
    data['accessToken'] = this.accessToken;
    data['privilege_id'] = this.privilegeId;
    data['employee_id'] = this.employeeId;
    return data;
  }
}
