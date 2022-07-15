class ProfileResponse {
  int? statusCode;
  String? message;
  Data? data;

  ProfileResponse({this.statusCode, this.message, this.data});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? id;
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
  String? employmentDate;
  String? expirationContractDate;
  String? createDate;
  String? closeDate;
  int? historical;
  int? officeLocationId;
  int? cooperativeId;
  String? vehicleShelterId;
  int? hasAccount;
  int? isDriver;

  Data(
      {this.id,
      this.taxCode,
      this.firstName,
      this.lastName,
      this.address,
      this.cap,
      this.city,
      this.country,
      this.email,
      this.phone,
      this.driverCode,
      this.employmentDate,
      this.expirationContractDate,
      this.createDate,
      this.closeDate,
      this.historical,
      this.officeLocationId,
      this.cooperativeId,
      this.vehicleShelterId,
      this.hasAccount,
      this.isDriver});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    employmentDate = json['employment_date'];
    expirationContractDate = json['expiration_contract_date'];
    createDate = json['create_date'];
    closeDate = json['close_date'];
    historical = json['historical'];
    officeLocationId = json['office_location_id'];
    cooperativeId = json['cooperative_id'];
    vehicleShelterId = json['vehicle_shelter_id'];
    hasAccount = json['has_account'];
    isDriver = json['is_driver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    data['employment_date'] = this.employmentDate;
    data['expiration_contract_date'] = this.expirationContractDate;
    data['create_date'] = this.createDate;
    data['close_date'] = this.closeDate;
    data['historical'] = this.historical;
    data['office_location_id'] = this.officeLocationId;
    data['cooperative_id'] = this.cooperativeId;
    data['vehicle_shelter_id'] = this.vehicleShelterId;
    data['has_account'] = this.hasAccount;
    data['is_driver'] = this.isDriver;
    return data;
  }
}
