class RecentChat {
  String? id;
  String? name;
  String? fromId;
  String? lastMessage;
  bool? read;
  String? sent;
  String? imageUrl;
  String? toId;
  String? type;

  RecentChat({
    this.id,
    this.name,
    this.fromId,
    this.lastMessage,
    this.read,
    this.sent,
    this.imageUrl,
    this.toId,
    this.type,
  });

  RecentChat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fromId = json['fromId'];
    lastMessage = json['lastMessage'];
    read = json['read'];
    sent = json['sent'];
    imageUrl = json['imageUrl'];
    toId = json['toId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['fromId'] = fromId;
    data['lastMessage'] = lastMessage;
    data['read'] = read;
    data['sent'] = sent;
    data['imageUrl'] = imageUrl;
    data['toId'] = toId;
    data['type'] = type;
    return data;
  }
}
