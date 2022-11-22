class ShiftsResponse {
  int? statusCode;
  String? message;
  Data? data;
  int? total;

  ShiftsResponse({this.statusCode, this.message, this.data, this.total});

  ShiftsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class Data {
  int? count;
  List<DataModels>? dataModels;

  Data({this.count, this.dataModels});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['dataModels'] != null) {
      dataModels = [];
      json['dataModels'].forEach((v) {
        dataModels?.add(new DataModels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.dataModels != null) {
      data['dataModels'] = this.dataModels?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataModels {
  int? id;
  String? year;
  String? month;
  String? day;
  int? type;
  String? timeStart;
  String? timeEnd;
  String? geolocationStart;
  String? geolocationEnd;
  int? officeLocationId;
  int? employeeId;
  int? vehicleId;
  int? attendanceproofId;
  String? employeeTimeStart;
  String? employeeTimeEnd;
  String? employeeGeolocationStart;
  String? employeeGeolocationEnd;
  int? validatedId;

  DataModels(
      {this.id,
      this.year,
      this.month,
      this.day,
      this.type,
      this.timeStart,
      this.timeEnd,
      this.geolocationStart,
      this.geolocationEnd,
      this.officeLocationId,
      this.employeeId,
      this.vehicleId,
      this.attendanceproofId,
      this.employeeTimeStart,
      this.employeeTimeEnd,
      this.employeeGeolocationStart,
      this.employeeGeolocationEnd,
      this.validatedId});

  DataModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    year = json['year'];
    month = json['month'];
    day = json['day'];
    type = json['type'];
    timeStart = json['time_start'];
    timeEnd = json['time_end'];
    geolocationStart = json['geolocation_start'];
    geolocationEnd = json['geolocation_end'];
    officeLocationId = json['office_location_id'];
    employeeId = json['employee_id'];
    vehicleId = json['vehicle_id'];
    attendanceproofId = json['attendanceproof_id'];
    employeeTimeStart = json['employee_time_start'];
    employeeTimeEnd = json['employee_time_end'];
    employeeGeolocationStart = json['employee_geolocation_start'];
    employeeGeolocationEnd = json['employee_geolocation_end'];
    validatedId = json['validated_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    data['type'] = this.type;
    data['time_start'] = this.timeStart;
    data['time_end'] = this.timeEnd;
    data['geolocation_start'] = this.geolocationStart;
    data['geolocation_end'] = this.geolocationEnd;
    data['office_location_id'] = this.officeLocationId;
    data['employee_id'] = this.employeeId;
    data['vehicle_id'] = this.vehicleId;
    data['attendanceproof_id'] = this.attendanceproofId;
    data['employee_time_start'] = this.employeeTimeStart;
    data['employee_time_end'] = this.employeeTimeEnd;
    data['employee_geolocation_start'] = this.employeeGeolocationStart;
    data['employee_geolocation_end'] = this.employeeGeolocationEnd;
    data['validated_id'] = this.validatedId;
    return data;
  }
}
