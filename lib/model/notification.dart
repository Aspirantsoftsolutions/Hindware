class MyNotification {
  String id;
  String type;
  String title;
  String message;
  String fromUserName;
  String fromUserId;
  String messageGroupId;

  MyNotification(
      {this.id,
      this.message,
      this.title,
      this.type,
      this.fromUserName,
      this.fromUserId,
      this.messageGroupId});

  MyNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    title = json['title'];
    type = json['type'];
    fromUserName = json['fromUserName'];
    fromUserId = json['fromUserId'];
    messageGroupId = json['messageGroupId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['title'] = this.title;
    data['type'] = this.type;
    data['fromUserName'] = this.fromUserName;
    data['fromUserId'] = this.fromUserId;
    data['messageGroupId'] = this.messageGroupId;
    return data;
  }
}
