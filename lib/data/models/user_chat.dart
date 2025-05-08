class UserChat {
  String? name;
  String? fromId;
  String? message;
  bool? read;
  String? sent;
  String? imageUrl;
  String? toId;
  String? type;

  UserChat({
    this.name,
    this.fromId,
    this.message,
    this.read,
    this.sent,
    this.imageUrl,
    this.toId,
    this.type,
  });

  UserChat.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fromId = json['fromId'];
    message = json['message'];
    read = json['read'];
    sent = json['sent'];
    imageUrl = json['imageUrl'];
    toId = json['toId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['fromId'] = fromId;
    data['message'] = message;
    data['read'] = read;
    data['sent'] = sent;
    data['imageUrl'] = imageUrl;
    data['toId'] = toId;
    data['type'] = type;
    return data;
  }
}
