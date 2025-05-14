class MyProfile {
  String? token;
  String? name;
  String? email;
  String? phone;
  String? about;
  int? age;
  String? imageUrl;

  MyProfile({
    this.name,
    this.age,
    this.email,
    this.phone,
    this.about,
    this.imageUrl,
    this.token,
  });

  MyProfile.fromJson(Map<String, dynamic> json) {
    name = json["name"] as String;
    email = json["email"] as String;
    phone = json["phone"] as String;
    about = json["about"] as String;
    age = json["age"] as int;
    imageUrl = json["imageUrl"] as String;
    token = json["token"] as String;
  }
}
