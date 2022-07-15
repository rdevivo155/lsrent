class VehicleModelResponse {
  int? statusCode;
  String? message;
  VehicleModelData? data;

  VehicleModelResponse({this.statusCode, this.message, this.data});

  VehicleModelResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null
        ? new VehicleModelData.fromJson(json['data'])
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

class VehicleModelData {
  int? id;
  String? brand;
  String? description;
  int? over35;
  int? powerTypeId;

  VehicleModelData(
      {this.id, this.brand, this.description, this.over35, this.powerTypeId});

  VehicleModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brand = json['brand'];
    description = json['description'];
    over35 = json['over_35'];
    powerTypeId = json['power_type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brand'] = this.brand;
    data['description'] = this.description;
    data['over_35'] = this.over35;
    data['power_type_id'] = this.powerTypeId;
    return data;
  }
}
