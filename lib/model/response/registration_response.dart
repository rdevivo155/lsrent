class RegistrationResponse {
  String? username;
  String? taxCode;
  String? accessToken;
  int? privilegeId;
  int? employeesId;

  RegistrationResponse(
      {this.username,
      this.taxCode,
      this.accessToken,
      this.privilegeId,
      this.employeesId});

  RegistrationResponse.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    taxCode = json['tax_code'];
    accessToken = json['accessToken'];
    privilegeId = json['privilege_id'];
    employeesId = json['employees_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['tax_code'] = this.taxCode;
    data['accessToken'] = this.accessToken;
    data['privilege_id'] = this.privilegeId;
    data['employees_id'] = this.employeesId;
    return data;
  }
}
