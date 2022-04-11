import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/notification_provider.dart';
import 'package:sasae_flutter_app/ui/notification/module/notification_list.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin {
  late final Future<void> _fetchNotificationFUTURE;
  late final NotificationProvider _notificationP;

  @override
  void initState() {
    super.initState();
    _fetchNotificationFUTURE = _fetchPost();
  }

  Future<void> _fetchPost() async {
    _notificationP = Provider.of<NotificationProvider>(context, listen: false);
    await _notificationP.fetchNotifications(demo: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _fetchNotificationFUTURE,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const CustomLoading()
              : Consumer<NotificationProvider>(
                  builder: (context, notificationP, child) =>
                      notificationP.getNotifications.isEmpty
                          ? const FetchError(
                              errorMessage: 'No Notifications yet...',
                            )
                          : NotificationList(
                              notifications: notificationP.getNotifications),
                ),
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
