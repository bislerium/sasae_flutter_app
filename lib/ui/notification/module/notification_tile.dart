import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/notification.dart';
import 'package:sasae_flutter_app/providers/notification_provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/notification_service.dart';
import 'package:sasae_flutter_app/ui/post/post_type/normal_post_screen.dart';
import 'package:sasae_flutter_app/ui/post/post_type/poll_post_screen.dart';
import 'package:sasae_flutter_app/ui/post/post_type/request_post_screen.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Icon(getIcon(notification.channel), color: color),
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
