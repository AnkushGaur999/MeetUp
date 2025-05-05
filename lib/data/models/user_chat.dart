class UserChat {
  String? fromId;
  String? message;
  bool? read;
  String? sent;
  String? toId;
  String? type;

  UserChat({
    this.fromId,
    this.message,
    this.read,
    this.sent,
    this.toId,
    this.type,
  });

  UserChat.fromJson(Map<String, dynamic> json) {
    fromId = json['fromId'];
    message = json['message'];
    read = json['read'];
    sent = json['sent'];
    toId = json['toId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fromId'] = fromId;
    data['message'] = message;
    data['read'] = read;
    data['sent'] = sent;
    data['toId'] = toId;
    data['type'] = type;
    return data;
  }
}
