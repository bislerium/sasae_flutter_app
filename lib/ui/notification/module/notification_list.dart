import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/notification.dart';
import 'package:sasae_flutter_app/ui/notification/module/notification_tile.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;
  final ScrollController scrollController;
  const NotificationList(
      {Key? key, required this.notifications, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: notifications.length,
      itemBuilder: (context, index) => NotificationTile(
        key: ValueKey(notifications[index].hashCode),
        notification: notifications[index],
      ),
    );
  }
}
