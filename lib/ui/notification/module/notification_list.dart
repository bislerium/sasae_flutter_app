import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/notification.dart';
import 'package:sasae_flutter_app/ui/notification/module/notification_tile.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;
  const NotificationList({Key? key, required this.notifications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: notifications
          .map((e) => NotificationTile(
                key: ValueKey(e.id),
                notification: e,
              ))
          .toList(),
    );
  }
}
