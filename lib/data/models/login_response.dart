class LoginResponse {
  bool? success;
  String? message;
  LoginData? data;

  LoginResponse({this.success, this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  String? fcmToken;
  String? name;
  String? email;
  String? phone;
  String? password;
  int? age;
  String? deviceId;

  LoginData({
    this.fcmToken,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.age,
    this.deviceId,
  });

  LoginData.fromJson(Map<String, dynamic> json) {
    fcmToken = json['fcmToken'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    age = json['age'];
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fcmToken'] = fcmToken;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['age'] = age;
    data['deviceId'] = deviceId;
    return data;
  }
}
