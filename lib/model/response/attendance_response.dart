class AttendanceResponse {
  String? year;
  String? month;
  String? day;
  int? type;
  String? timeStart;
  String? timeEnd;
  String? geolocationStart;
  String? geolocationEnd;
  int? userId;
  int? attendanceproofId;
  int? vehicleId;
  int? id;

  AttendanceResponse(
      {this.year,
      this.month,
      this.day,
      this.type,
      this.timeStart,
      this.timeEnd,
      this.geolocationStart,
      this.geolocationEnd,
      this.userId,
      this.attendanceproofId,
      this.vehicleId,
      this.id});

  AttendanceResponse.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
    day = json['day'];
    type = json['type'];
    timeStart = json['time_start'];
    timeEnd = json['time_end'];
    geolocationStart = json['geolocation_start'];
    geolocationEnd = json['geolocation_end'];
    userId = json['user_id'];
    attendanceproofId = json['attendanceproof_id'];
    vehicleId = json['vehicle_id'];
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
    data['user_id'] = this.userId;
    data['attendanceproof_id'] = this.attendanceproofId;
    data['vehicle_id'] = this.vehicleId;
    data['id'] = this.id;
    return data;
  }
}
