class VehicleResponse {
  int? statusCode;
  String? message;
  VehicleData? data;

  VehicleResponse({this.statusCode, this.message, this.data});

  VehicleResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? new VehicleData.fromJson(json['data']) : null;
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

class VehicleData {
  int? id;
  String? carPlate;
  String? carCertificate;
  String? insuranceCertificate;
  String? revisionExpirationDate;
  String? insuranceExpirationDate;
  String? powerRevisionExpirationDate;
  String? tachographExpirationDate;
  int? substitution;
  int? workingStatus;
  String? createDate;
  String? closeDate;
  int? historical;
  int? officeLocationId;
  int? vehicleModelId;
  String? employeeId;

  VehicleData(
      {this.id,
      this.carPlate,
      this.carCertificate,
      this.insuranceCertificate,
      this.revisionExpirationDate,
      this.insuranceExpirationDate,
      this.powerRevisionExpirationDate,
      this.tachographExpirationDate,
      this.substitution,
      this.workingStatus,
      this.createDate,
      this.closeDate,
      this.historical,
      this.officeLocationId,
      this.vehicleModelId,
      this.employeeId});

  VehicleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carPlate = json['car_plate'];
    carCertificate = json['car_certificate'];
    insuranceCertificate = json['insurance_certificate'];
    revisionExpirationDate = json['revision_expiration_date'];
    insuranceExpirationDate = json['insurance_expiration_date'];
    powerRevisionExpirationDate = json['power_revision_expiration_date'];
    tachographExpirationDate = json['tachograph_expiration_date'];
    substitution = json['substitution'];
    workingStatus = json['working_status'];
    createDate = json['create_date'];
    closeDate = json['close_date'];
    historical = json['historical'];
    officeLocationId = json['office_location_id'];
    vehicleModelId = json['vehicle_model_id'];
    employeeId = json['employee_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['car_plate'] = this.carPlate;
    data['car_certificate'] = this.carCertificate;
    data['insurance_certificate'] = this.insuranceCertificate;
    data['revision_expiration_date'] = this.revisionExpirationDate;
    data['insurance_expiration_date'] = this.insuranceExpirationDate;
    data['power_revision_expiration_date'] = this.powerRevisionExpirationDate;
    data['tachograph_expiration_date'] = this.tachographExpirationDate;
    data['substitution'] = this.substitution;
    data['working_status'] = this.workingStatus;
    data['create_date'] = this.createDate;
    data['close_date'] = this.closeDate;
    data['historical'] = this.historical;
    data['office_location_id'] = this.officeLocationId;
    data['vehicle_model_id'] = this.vehicleModelId;
    data['employee_id'] = this.employeeId;
    return data;
  }
}
