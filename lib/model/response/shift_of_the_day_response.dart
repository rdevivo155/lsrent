class ShiftOfTheDayResponse {
  int? statusCode;
  String? message;
  ShiftOfTheDayData? data;

  ShiftOfTheDayResponse({this.statusCode, this.message, this.data});

  ShiftOfTheDayResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'] != null ? json['statusCode'] : json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new ShiftOfTheDayData.fromJson(json['data'])
        : null;
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

class ShiftOfTheDayData {
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
  int? attendanceproofId;
  int? vehicleId;
  String? employeeTimeStart;
  String? employeeTimeEnd;
  String? employeeGeolocationStart;
  String? employeeGeolocationEnd;
  int? id;

  ShiftOfTheDayData(
      {this.year,
      this.month,
      this.day,
      this.type,
      this.timeStart,
      this.timeEnd,
      this.geolocationStart,
      this.geolocationEnd,
      this.officeLocationId,
      this.employeeId,
      this.attendanceproofId,
      this.vehicleId,
      this.employeeTimeStart,
      this.employeeTimeEnd,
      this.employeeGeolocationStart,
      this.employeeGeolocationEnd,
      this.id});

  ShiftOfTheDayData.fromJson(Map<String, dynamic> json) {
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
    attendanceproofId = json['attendanceproof_id'];
    vehicleId = json['vehicle_id'];
    employeeTimeStart = json['employee_time_start'];
    employeeTimeEnd = json['employee_time_end'];
    employeeGeolocationStart = json['employee_geolocation_start'];
    employeeGeolocationEnd = json['employee_geolocation_end'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['attendanceproof_id'] = this.attendanceproofId;
    data['vehicle_id'] = this.vehicleId;
    data['employee_time_start'] = this.employeeTimeStart;
    data['employee_time_end'] = this.employeeTimeEnd;
    data['employee_geolocation_start'] = this.employeeGeolocationStart;
    data['employee_geolocation_end'] = this.employeeGeolocationEnd;
    data['id'] = this.id;
    return data;
  }
}
