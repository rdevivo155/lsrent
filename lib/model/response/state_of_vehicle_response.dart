class StatusOfVehicleResponse {
  int? statusCode;
  String? message;
  Data? data;

  StatusOfVehicleResponse({this.statusCode, this.message, this.data});

  StatusOfVehicleResponse.fromJson(Map<String, dynamic> json) {
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
  String? pictureId;
  String? title;
  String? description;
  String? vehicleId;
  String? officeLocationId;
  String? employeeId;
  int? timestamp;
  Null? fileName;
  int? id;

  Data(
      {this.pictureId,
      this.title,
      this.description,
      this.vehicleId,
      this.officeLocationId,
      this.employeeId,
      this.timestamp,
      this.fileName,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    pictureId = json['picture_id'];
    title = json['title'];
    description = json['description'];
    vehicleId = json['vehicle_id'];
    officeLocationId = json['office_location_id'];
    employeeId = json['employee_id'];
    timestamp = json['timestamp'];
    fileName = json['file_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['picture_id'] = this.pictureId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['vehicle_id'] = this.vehicleId;
    data['office_location_id'] = this.officeLocationId;
    data['employee_id'] = this.employeeId;
    data['timestamp'] = this.timestamp;
    data['file_name'] = this.fileName;
    data['id'] = this.id;
    return data;
  }
}
