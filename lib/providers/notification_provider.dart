import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_store/json_store.dart';
import 'package:sasae_flutter_app/config.dart';
import 'package:sasae_flutter_app/models/notification.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/providers/startup_provider.dart';
import 'package:sasae_flutter_app/services/notification_service.dart';

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
    _notifications.insert(0, notification);
    await jsonStore.setItem(
        'notification-${notification.id}', notification.toMap());
    notifyListeners();
  }

  Future<void> markRead(int notificationID) async {
    NotificationModel notification = _notifications
        .firstWhere((element) => element.id == notificationID)
      ..isRead = true;
    await jsonStore.setItem(
        'notification-$notificationID', notification.toMap());
    notifyListeners();
  }

  Future<void> markAsReadAll() async {
    for (var element in _notifications) {
      element.isRead = true;
    }
    await flushNotifications();
    notifyListeners();
  }

  Future<void> clearNotification() async {
    _notifications.clear();
    await jsonStore.deleteLike('notification%');
    notifyListeners();
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
    await jsonStore.commitBatch(batch);
  }

  void disposeNotifications() => _notifications.clear();

  Future<void> fetchNotifications() async {
    if (StartupProvider.getIsDemo) {
      await delay();
      _notifications = _randNotifications();
    } else {
      List<Map<String, dynamic>>? json =
          await jsonStore.getListLike('notification-%');
      _notifications = json != null
          ? json
              .map((element) => NotificationModel.fromMap(element))
              .toList()
              .reversed
              .toList()
          : [];
    }
  }
}
