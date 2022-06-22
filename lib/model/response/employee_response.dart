class EmployeeResponse {
  String? taxCode;
  String? firstName;
  String? lastName;
  String? address;
  String? cap;
  String? city;
  String? country;
  String? email;
  String? phone;
  String? driverCode;
  int? officeLocationId;
  int? cooperativeId;
  int? id;

  EmployeeResponse(
      {this.taxCode,
      this.firstName,
      this.lastName,
      this.address,
      this.cap,
      this.city,
      this.country,
      this.email,
      this.phone,
      this.driverCode,
      this.officeLocationId,
      this.cooperativeId,
      this.id});

  EmployeeResponse.fromJson(Map<String, dynamic> json) {
    taxCode = json['tax_code'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    cap = json['cap'];
    city = json['city'];
    country = json['country'];
    email = json['email'];
    phone = json['phone'];
    driverCode = json['driver_code'];
    officeLocationId = json['office_location_id'];
    cooperativeId = json['cooperative_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tax_code'] = this.taxCode;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['address'] = this.address;
    data['cap'] = this.cap;
    data['city'] = this.city;
    data['country'] = this.country;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['driver_code'] = this.driverCode;
    data['office_location_id'] = this.officeLocationId;
    data['cooperative_id'] = this.cooperativeId;
    data['id'] = this.id;
    return data;
  }
}
