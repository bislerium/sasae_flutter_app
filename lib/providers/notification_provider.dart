import 'package:flutter/cupertino.dart';
import 'package:json_store/json_store.dart';
import 'package:sasae_flutter_app/models/notification.dart';

class NotificationProvider extends ChangeNotifier {
  final JsonStore jsonStore;
  List<NotificationModel> _notifications;

  NotificationProvider()
      : jsonStore = JsonStore(),
        _notifications = [];

  List<NotificationModel> get getNotifications => _notifications;

  Future<void> addNotification(NotificationModel notification) async {
    _notifications.add(notification);
    print('------------------------');
    print(_notifications);
    print('------------------------');
    await jsonStore.setItem(
        'notification-${notification.id}', notification.toMap());
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

  Future<void> fetchNotifications() async {
    List<Map<String, dynamic>>? json =
        await jsonStore.getListLike('messages-%');
    _notifications = json != null
        ? json.map((element) => NotificationModel.fromMap(element)).toList()
        : [];
    print('================');
    print(json);
    print('================');
  }
}
