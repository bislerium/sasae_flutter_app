import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_store/json_store.dart';
import 'package:sasae_flutter_app/models/notification.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';

import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final JsonStore jsonStore;
  List<NotificationModel> _notifications;

  NotificationProvider()
      : jsonStore = JsonStore(),
        _notifications = [];

  List<NotificationModel> get getNotifications => _notifications;

  List<NotificationModel> _randNotifications() {
    return List.generate(faker.randomGenerator.integer(20), (index) {
      var channel = faker.randomGenerator.element(
        NotificationChannel.values,
      );
      return NotificationModel(
        id: index,
        title: faker.lorem.words(faker.randomGenerator.integer(5)).join(' '),
        body: faker.lorem.sentences(faker.randomGenerator.integer(5)).join(' '),
        channel: channel,
        postType: channel == NotificationChannel.remove
            ? null
            : faker.randomGenerator.element(PostType.values),
        postID: channel == NotificationChannel.remove
            ? null
            : faker.randomGenerator.integer(50),
        isRead: faker.randomGenerator.boolean(),
      );
    });
  }

  Future<void> addNotification(NotificationModel notification) async {
    _notifications.add(notification);
    print('added');
    // await jsonStore.setItem(
    //     'notification-${notification.id}', notification.toMap());
    notifyListeners();
  }

  Future<void> markRead(int notificationID) async {
    NotificationModel _ = _notifications
        .firstWhere((element) => element.id == notificationID)
      ..isRead = true;
    await jsonStore.setItem('notification-$notificationID', _.toMap());
    notifyListeners();
  }

  Future<void> markAsReadAll() async {
    for (var element in _notifications) {
      element.isRead = true;
    }
    await flushNotifications();
  }

  Future<void> clearNotification() async {
    _notifications.clear();
    await jsonStore.clearDataBase();
  }

  Future<void> flushNotifications() async {
    var batch = await jsonStore.startBatch();
    await Future.forEach<NotificationModel>(_notifications,
        (notificaton) async {
      await jsonStore.setItem(
        'notification-${notificaton.id}',
        notificaton.toMap(),
        batch: batch,
      );
    });
    jsonStore.commitBatch(batch);
  }

  Future<void> fetchNotifications({bool demo = false}) async {
    if (demo) {
      _notifications = _randNotifications();
    } else {
      List<Map<String, dynamic>>? json =
          await jsonStore.getListLike('messages-%');
      _notifications = json != null
          ? json.map((element) => NotificationModel.fromMap(element)).toList()
          : [];
    }
  }
}
