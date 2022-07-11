import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/notification.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/notification_provider.dart';
import 'package:sasae_flutter_app/providers/page_navigator_provider.dart';
import 'package:sasae_flutter_app/services/notification_service.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/notification/notification_page.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';
import 'package:sasae_flutter_app/ui/ngo/ngo_page.dart';
import 'package:sasae_flutter_app/ui/post/post_page.dart';
import 'package:sasae_flutter_app/ui/profile/user_profile_page.dart';
import 'package:sasae_flutter_app/ui/setting/setting_page.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';
import 'package:shake/shake.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late final PageNavigatorProvider _pageNavigatorP;
  late final StreamSubscription<ConnectivityResult> _subscription;
  late final ShakeDetector _shakeDetector;

  @override
  void initState() {
    super.initState();
    _subscription = getConnectivitySubscription(context);
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () {
        print('hghg-------------------');
        showSnackBar(
            context: context, message: 'Shaked'); // Do stuff on phone shake
      },
    );

    _pageNavigatorP =
        Provider.of<PageNavigatorProvider>(context, listen: false);
    NotificationService.getInstance().initialize(context);
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        var additionalData = event.data;
        int id =
            Provider.of<AuthProvider>(context, listen: false).auth!.accountID;
        if (id != int.parse(additionalData['account_id'])) return;
        NotificationModel notificationModel = NotificationModel(
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
            .addNotification(notificationModel);
        NotificationService.getInstance().notify(notification);
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _shakeDetector.stopListening();
    _pageNavigatorP.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<PageNavigatorProvider>(
        builder: (context, pageNavigatorP, child) {
      pageNavigatorP.initPageController();
      return Scaffold(
        body: SafeArea(
          child: PageView(
            onPageChanged: (index) => _pageNavigatorP.setPageIndex = index,
            controller: pageNavigatorP.getPageController,
            physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
            children: const [
              UserProfilePage(),
              NGOPage(),
              PostPage(),
              NotificationPage(),
              SettingScreen(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: _pageNavigatorP.getPageIndex == 0 &&
                Provider.of<ProfileSettingFABProvider>(context).getShowFAB
            ? CustomFAB(
                key: const Key('updateProfileFAB'),
                text: 'Update Profile',
                icon: Icons.edit_rounded,
                func: Provider.of<ProfileSettingFABProvider>(context)
                    .getOnPressedHandler,
                tooltip: 'Update Profile',
              )
            : _pageNavigatorP.getPageIndex == 2 &&
                    Provider.of<PostFABProvider>(context).getShowFAB
                ? CustomFAB(
                    key: const Key('postFAB'),
                    text: 'Post',
                    icon: Icons.add,
                    func: Provider.of<PostFABProvider>(context)
                        .getOnPressedHandler,
                    tooltip: 'Post a Post',
                  )
                : _pageNavigatorP.getPageIndex == 3 &&
                        Provider.of<NotificationActionFABProvider>(context)
                            .getShowFAB
                    ? Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        spacing: 20,
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              BetterFeedback.of(context).show((feedback) async {
                                // draft an email and send to developer
                                final String screenshotFilePath =
                                    await writeImageToStorage(
                                        feedback.screenshot);

                                final Email email = Email(
                                  body: feedback.text,
                                  subject: 'App Feedback',
                                  recipients: ['bigc.liaise@gmail.com'],
                                  attachmentPaths: [
                                    screenshotFilePath,
                                  ],
                                  isHTML: false,
                                );
                                await FlutterEmailSender.send(email);
                              });
                              // showCustomDialog(
                              //     context: context,
                              //     title: 'Clear Notifications',
                              //     content: 'You cannot undo this action.',
                              //     okFunc: () async {
                              //       await Provider.of<NotificationProvider>(
                              //               context,
                              //               listen: false)
                              //           .clearNotification();
                              //       if (!mounted) return;
                              //       Navigator.of(context).pop();
                              //     });
                            },
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            child: const Icon(Icons.clear_all_rounded),
                          ),
                          FloatingActionButton.large(
                              onPressed: () async =>
                                  Provider.of<NotificationProvider>(context,
                                          listen: false)
                                      .markAsReadAll(),
                              child: const Icon(Icons.done_all))
                        ],
                      )
                    : _pageNavigatorP.getPageIndex == 4
                        ? CustomFAB(
                            key: const Key('logoutFAB'),
                            text: 'Logout',
                            icon: Icons.logout,
                            func: Provider.of<LogoutFABProvider>(context)
                                .getOnPressedHandler,
                            foreground: Theme.of(context).colorScheme.onError,
                            background: Theme.of(context).colorScheme.error,
                            tooltip: 'Logout',
                          )
                        : null,
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              key: Key('profileNB'),
              icon: Icon(Icons.account_circle_outlined),
              selectedIcon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
            NavigationDestination(
              key: Key('ngoNB'),
              icon: Icon(Icons.health_and_safety_outlined),
              selectedIcon: Icon(Icons.health_and_safety),
              label: 'NGO',
            ),
            NavigationDestination(
              key: Key('feedNB'),
              icon: Icon(Icons.feed_outlined),
              selectedIcon: Icon(Icons.feed),
              label: 'Feed',
            ),
            NavigationDestination(
              key: Key('notificationNB'),
              icon: Icon(Icons.notifications_outlined),
              selectedIcon: Icon(Icons.notifications),
              label: 'Notification',
            ),
            NavigationDestination(
              key: Key('settingNB'),
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
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
