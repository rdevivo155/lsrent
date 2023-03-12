class PushResponse {
  int? statusCode;
  String? message;
  List<PushData> ? data;

  PushResponse({this.statusCode, this.message, this.data});

  PushResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PushData>[];
      json['data'].forEach((v) {
        data!.add(new PushData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!;
    }
    return data;
  }
}

class PushData {
  int? id;
  int? idUser;
  String? token;
  

  PushData(
      {this.id,
      this.idUser,
      this.token,
      });

  PushData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['id_user'];
    token = json['token'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_user'] = this.idUser;
    data['token'] = this.token;
    return data;
  }
}
