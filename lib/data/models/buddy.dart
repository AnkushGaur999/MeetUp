class Buddy {
  String? token;
  String? name;
  String? email;
  String? phone;
  String? about;
  String? fcmToken;
  int? age;
  String? imageUrl;

  Buddy({this.name, this.phone, this.email, this.age, this.imageUrl});

  Buddy.fromJson(Map<String, dynamic> json) {
    token = json["token"] as String;
    name = json["name"] as String;
    age = json["age"] as int;
    email = json["email"] as String;
    about = json["about"] as String;
    phone = json["phone"] as String;
    fcmToken = json["fcmToken"] as String;
    imageUrl = json["imageUrl"] as String;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "token": token,
      "name": name,
      "email": email,
      "age": age,
      "phone": phone,
      "fcmToken": fcmToken,
      "about": about,
      "imageUrl": imageUrl,
    };
  }
}
