import 'package:faker/faker.dart';
import 'package:sasae_flutter_app/models/notification.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/notification_service.dart';
import 'package:test/test.dart';

void main() {
  late Map<String, dynamic> json;
  late NotificationModel notificationModel;

  setUpAll(() {
    bool _ = faker.randomGenerator.boolean();
    json = {
      'id': faker.randomGenerator.integer(1000),
      'title': faker.lorem.word(),
      'body': faker.lorem.sentences(5).join(''),
      'channel': faker.randomGenerator.element(NotificationChannel.values).name,
      'post_type':
          _ ? faker.randomGenerator.element(PostType.values).name : null,
      'post_id': _ ? faker.randomGenerator.integer(1000) : null,
      'isRead': faker.randomGenerator.boolean(),
    };
  });

  test('JSON deserialized to NotificationModel Instance', () {
    notificationModel = NotificationModel.fromAPIResponse(json);
    expect(notificationModel, isA<NotificationModel>());
  });

  test('Notification ID casted', () {
    expect(notificationModel.id, isA<int>());
  });

  test('Title casted', () {
    expect(notificationModel.title, json['title']);
  });

  test('Body casted', () {
    expect(notificationModel.body, json['body']);
  });

  test('Channel casted', () {
    expect(notificationModel.channel,
        NotificationModel.getNotificationChannel(json['channel']));
  });

  test('Post type casted', () {
    expect(
        notificationModel.postType,
        json['post_type'] == null
            ? null
            : NotificationModel.getPostType(json['post_type']));
  });

  test('Post ID casted', () {
    expect(notificationModel.postID, json['post_id']);
  });

  test('Is-Read casted', () {
    expect(notificationModel.isRead, json['isRead']);
  });
}
