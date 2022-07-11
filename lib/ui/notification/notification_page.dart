import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
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
  late final ScrollController _scrollController;
  late final Future<void> _fetchNotificationFUTURE;
  late final NotificationProvider _notificationP;
  late final NotificationActionFABProvider _notificationFABP;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(notificationActionFABListenScroll);
    _fetchNotificationFUTURE = _fetchNotifications();
  }

  @override
  void dispose() {
    _scrollController.removeListener(notificationActionFABListenScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchNotifications() async {
    _notificationP = Provider.of<NotificationProvider>(context, listen: false);
    _notificationFABP =
        Provider.of<NotificationActionFABProvider>(context, listen: false);
    await _notificationP.fetchNotifications();
    if (_notificationP.getNotifications.isNotEmpty) {
      _notificationFABP.setShowFAB = true;
    }
  }

  void notificationActionFABListenScroll() {
    var direction = _scrollController.position.userScrollDirection;
    direction == ScrollDirection.reverse
        ? _notificationFABP.setShowFAB = false
        : _notificationFABP.setShowFAB = true;
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
                      notificationP.getNotifications.isNotEmpty
                          ? NotificationList(
                              scrollController: _scrollController,
                              notifications: notificationP.getNotifications,
                            )
                          : const ErrorView(
                              errorMessage: 'No Notifications yet 😴...',
                            ),
                ),
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
