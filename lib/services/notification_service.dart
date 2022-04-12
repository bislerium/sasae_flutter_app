import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static NotificationService? _notificationService;

  NotificationService._();

  factory NotificationService.getInstance() =>
      _notificationService ??= NotificationService._();

  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  late AndroidNotificationChannel channel;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void initialize() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'post_channel',
        'Post Notifications',
        description: 'This channel is used for notifications related to post.',
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      );

      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (String? route) async {
        if (route != null) {
          print('route -> $route');
          // Navigator.of(context).pushNamed(route);
        }
      });

      /// Create an Android Notification Channel.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance.subscribeToTopic('post');

      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void notify(RemoteNotification notification) async {
    try {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
          ),
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}

enum NotificationChannel {
  reaction,
  poll,
  join,
  petition,
  poke,
  remove,
  verify,
}
