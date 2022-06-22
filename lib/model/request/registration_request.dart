class RegistrationRequest {
  String? username;
  String? password;
  String? taxCode;
  bool? terms;

  RegistrationRequest({this.username, this.password, this.taxCode, this.terms});

  RegistrationRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    taxCode = json['tax_code'];
    terms = json['terms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['tax_code'] = this.taxCode;
    data['terms'] = this.terms;
    return data;
  }
}
