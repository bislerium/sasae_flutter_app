import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/notification.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/notification_provider.dart';
import 'package:sasae_flutter_app/providers/page_navigator_provider.dart';
import 'package:sasae_flutter_app/services/notification_service.dart';
import 'package:sasae_flutter_app/ui/notification/notification_page.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';
import 'package:sasae_flutter_app/ui/ngo/ngo_page.dart';
import 'package:sasae_flutter_app/ui/post/post_page.dart';
import 'package:sasae_flutter_app/ui/profile/user_profile_page.dart';
import 'package:sasae_flutter_app/ui/setting/setting_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageNavigatorProvider _pageNavigatorP;

  @override
  void initState() {
    super.initState();
    NotificationService.getInstance().initialize(context);
    _pageNavigatorP =
        Provider.of<PageNavigatorProvider>(context, listen: false);
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        var additionalData = event.data;
        int id =
            Provider.of<AuthProvider>(context, listen: false).auth!.accountID;
        if (id != int.parse(additionalData['account_id'])) return;
        NotificationModel _ = NotificationModel(
            id: notification.hashCode,
            title: notification.title!,
            body: notification.body!,
            channel: NotificationModel.getNotificationChannel(
                additionalData['channel']),
            postType: additionalData['post_type'] == null
                ? null
                : NotificationModel.getPostType(additionalData['post_type']),
            postID: additionalData['post_id'] == null
                ? null
                : int.parse(additionalData['post_id']));
        Provider.of<NotificationProvider>(context, listen: false)
            .addNotification(_);
        NotificationService.getInstance().notify(notification);
      }
    });
  }

  @override
  void dispose() {
    _pageNavigatorP.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PageNavigatorProvider>(
        builder: (context, pageNavigatorP, child) {
      pageNavigatorP.initPageController();
      return Scaffold(
        body: SafeArea(
          child: PageView(
            children: const [
              UserProfilePage(),
              NGOPage(),
              PostPage(),
              NotificationPage(),
              SettingScreen(),
            ],
            onPageChanged: (index) => _pageNavigatorP.setPageIndex = index,
            controller: pageNavigatorP.getPageController,
            physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _pageNavigatorP.getPageIndex == 0 &&
                Provider.of<ProfileSettingFABProvider>(context).getShowFAB
            ? CustomFAB(
                text: 'Update Profile',
                icon: Icons.edit_rounded,
                func: Provider.of<ProfileSettingFABProvider>(context)
                    .getOnPressedHandler,
              )
            : _pageNavigatorP.getPageIndex == 2 &&
                    Provider.of<PostFABProvider>(context).getShowFAB
                ? CustomFAB(
                    text: 'Post',
                    icon: Icons.post_add,
                    func: Provider.of<PostFABProvider>(context)
                        .getOnPressedHandler,
                  )
                : _pageNavigatorP.getPageIndex == 4
                    ? CustomFAB(
                        text: 'Logout',
                        icon: Icons.logout,
                        func: Provider.of<LogoutFABProvider>(context)
                            .getOnPressedHandler,
                        foreground: Theme.of(context).colorScheme.onError,
                        background: Theme.of(context).colorScheme.error,
                      )
                    : null,
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
            iconTheme: MaterialStateProperty.all(
              IconThemeData(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          child: NavigationBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.account_circle_outlined),
                selectedIcon: Icon(Icons.account_circle),
                label: 'Profile',
              ),
              NavigationDestination(
                icon: Icon(Icons.health_and_safety_outlined),
                selectedIcon: Icon(Icons.health_and_safety),
                label: 'NGO',
              ),
              NavigationDestination(
                icon: Icon(Icons.feed_outlined),
                selectedIcon: Icon(Icons.feed),
                label: 'Feed',
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications_outlined),
                selectedIcon: Icon(Icons.notifications),
                label: 'Notification',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Setting',
              ),
            ],
            selectedIndex: _pageNavigatorP.getPageIndex, //New
            onDestinationSelected: (index) {
              _pageNavigatorP.setPageIndex = index;
              _pageNavigatorP.navigateToPage();
            },
          ),
        ),
      );
    });
  }
}
