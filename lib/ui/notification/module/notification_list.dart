import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/notification.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/notification_provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/notification_service.dart';
import 'package:sasae_flutter_app/ui/post/type/normal_post_screen.dart';
import 'package:sasae_flutter_app/ui/post/type/poll_post_screen.dart';
import 'package:sasae_flutter_app/ui/post/type/request_post_screen.dart';
import 'package:sasae_flutter_app/ui/misc/custom_card.dart';

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
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: notifications.length,
      itemBuilder: (context, index) => NotificationTile(
        key: ValueKey(notifications[index].hashCode),
        notification: notifications[index],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  const NotificationTile({Key? key, required this.notification})
      : super(key: key);

  IconData getIcon(NotificationChannel channel) {
    switch (channel) {
      case NotificationChannel.reaction:
        return Icons.add_reaction_rounded;
      case NotificationChannel.poll:
        return Icons.poll_rounded;
      case NotificationChannel.join:
        return Icons.handshake;
      case NotificationChannel.petition:
        return Icons.gesture;
      case NotificationChannel.poke:
        return Icons.waving_hand;
      case NotificationChannel.remove:
        return Icons.remove_circle_outline_rounded;
      case NotificationChannel.verify:
        return Icons.verified_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? color =
        notification.isRead ? null : Theme.of(context).colorScheme.primary;
    return CustomCard(
      child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Icon(getIcon(notification.channel), color: color),
          horizontalTitleGap: 10,
          title: Text(
            notification.title,
            style: TextStyle(
              color: color,
            ),
          ),
          subtitle: Text(
            notification.body,
            style: TextStyle(
              color: color,
            ),
          ),
          onTap: () {
            Provider.of<NotificationProvider>(context, listen: false)
                .markRead(notification.id);
            late String routeName;
            switch (notification.postType) {
              case PostType.normal:
                routeName = NormalPostScreen.routeName;
                break;
              case PostType.poll:
                routeName = PollPostScreen.routeName;
                break;
              case PostType.request:
                routeName = RequestPostScreen.routeName;
                break;
              case null:
                return;
            }
            if (notification.postID == null) return;
            Navigator.pushNamed(context, routeName,
                arguments: {'postID': notification.postID!});
          }),
    );
  }
}
