import 'dart:convert';

import 'package:sasae_flutter_app/services/notification_service.dart';

class NotificationModel {
  int id;
  String title;
  String body;
  NotificationChannel channel;
  int? postID;
  bool isRead;
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.channel,
    this.postID,
    this.isRead = false,
  });

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    NotificationChannel? channel,
    int? postID,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      channel: channel ?? this.channel,
      postID: postID ?? this.postID,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'channel': channel.name,
      'postID': postID,
      'isRead': isRead,
    };
  }

  static NotificationChannel getNotificationChannel(String channel) =>
      NotificationChannel.values
          .firstWhere((element) => element.name == channel);

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      channel: getNotificationChannel(map['channel']),
      postID: map['postID']?.toInt(),
      isRead: map['isRead'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, body: $body, channel: $channel, postID: $postID, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.channel == channel &&
        other.postID == postID &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        channel.hashCode ^
        postID.hashCode ^
        isRead.hashCode;
  }
}
