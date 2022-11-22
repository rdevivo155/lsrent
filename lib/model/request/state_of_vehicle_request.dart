class StatusOfVehicleRequest {
  String? pictureId;
  String? title;
  String? description;
  int? vehicleId;
  int? officeLocationId;
  int? employeeId;

  StatusOfVehicleRequest(
      {this.pictureId,
      this.title,
      this.description,
      this.vehicleId,
      this.officeLocationId,
      this.employeeId});

  StatusOfVehicleRequest.fromJson(Map<String, dynamic> json) {
    pictureId = json['picture_id'];
    title = json['title'];
    description = json['description'];
    vehicleId = json['vehicle_id'];
    officeLocationId = json['office_location_id'];
    employeeId = json['employee_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['picture_id'] = this.pictureId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['vehicle_id'] = this.vehicleId;
    data['office_location_id'] = this.officeLocationId;
    data['employee_id'] = this.employeeId;
    return data;
  }
}
