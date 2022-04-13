import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/page_navigator_provider.dart';
import 'package:sasae_flutter_app/ui/home_screen.dart';
import 'package:sasae_flutter_app/ui/post/post_type/normal_post_screen.dart';

class NotificationService {
  static NotificationService? _notificationService;

  NotificationService._();

  factory NotificationService.getInstance() =>
      _notificationService ??= NotificationService._();

  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  late AndroidNotificationChannel channel;

  void initialize(BuildContext context) async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    if (!kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic('post');

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: AndroidInitializationSettings(
            "@drawable/ic_stat_notification_icon"),
      );

      _notificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: (String? route) async {
          Navigator.popUntil(
            context,
            ((route) => route.isFirst),
          );
          Provider.of<PageNavigatorProvider>(context, listen: false)
            ..setPageIndex = 3
            ..navigateToPage();
        },
      );

      channel = const AndroidNotificationChannel(
        'post_channel',
        'Post Notifications',
        description: 'This channel is used for notifications related to post.',
        importance: Importance.high,
      );

      /// Create an Android Notification Channel.
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

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
      _notificationsPlugin.show(
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
