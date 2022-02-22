import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './profile/user_profile.dart';
import './auth/login_screen.dart';
import './post/post_screen.dart';
import './ngo/ngo_screen.dart';
import './setting.dart';
import 'misc/custom_widgets.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pc;
  int _selectedNavIndex;
  List<String> screenTitle;
  bool showFAB;

  _HomePageState()
      : _selectedNavIndex = 2,
        _pc = PageController(
          initialPage: 2,
        ),
        screenTitle = ['NGO', 'Feed', 'Notification', 'Profile', 'Setting'],
        showFAB = true;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  ListTile getPostModalItem(BuildContext ctx, IconData icon, String title,
      String subtitle, VoidCallback func) {
    return ListTile(
      iconColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onSurface,
      leading: Icon(
        icon,
        size: 30,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: func,
    );
  }

  void showPostOptionModal(BuildContext ctx) => showModalSheet(
        ctx: ctx,
        children: [
          getPostModalItem(
              ctx, Icons.file_present_sharp, 'Normal Post', 'Attach an Image!',
              () {
            Navigator.pop(context);
          }),
          getPostModalItem(ctx, Icons.poll, 'Poll Post', 'Poll the Options!',
              () {
            Navigator.pop(context);
          }),
          getPostModalItem(
              ctx, Icons.help_center, 'Request Post', 'Request to Change!', () {
            Navigator.pop(context);
          }),
        ],
      );

  FloatingActionButton getFloatingActionButton({
    required String text,
    required IconData icon,
    required VoidCallback function,
    Color? buttonColor,
    required Color foreground,
  }) {
    return FloatingActionButton.extended(
      onPressed: function,
      label: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      icon: Icon(icon),
      backgroundColor: buttonColor,
      foregroundColor: foreground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
    );
  }

  Widget? _indexPerFAB() {
    switch (_selectedNavIndex) {
      case 0:
        {
          return SizedBox(
            height: 60,
            width: 150,
            child: getFloatingActionButton(
              text: 'Edit profile',
              buttonColor: Theme.of(context).colorScheme.primary,
              icon: Icons.edit,
              function: () {},
              foreground: Theme.of(context).colorScheme.onPrimary,
            ),
          );
        }
      case 2:
        {
          return SizedBox(
            height: 60,
            width: 120,
            child: getFloatingActionButton(
              text: 'Post',
              buttonColor: Theme.of(context).colorScheme.primary,
              icon: Icons.post_add,
              function: () => showPostOptionModal(context),
              foreground: Theme.of(context).colorScheme.onPrimary,
            ),
          );
        }
      case 4:
        {
          return SizedBox(
            height: 60,
            width: 120,
            child: getFloatingActionButton(
              text: 'Logout',
              icon: Icons.logout,
              function: () => showCustomDialog(
                context: context,
                title: 'Logout',
                content: 'Do it with passion or not at all',
                okFunc: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.routeName, (Route<dynamic> route) => false),
              ),
              foreground: Theme.of(context).colorScheme.onError,
              buttonColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      default:
        {
          return null;
        }
    }
  }

  Widget _getBottomNavBar() => NavigationBarTheme(
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
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
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
          selectedIndex: _selectedNavIndex, //New
          onDestinationSelected: (index) => {
            setState(() {
              _selectedNavIndex = index;
              _pc.animateToPage(
                _selectedNavIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            })
          },
        ),
      );

  Widget _getPageView() => PageView(
        children: const [
          UserProfile(),
          NGOScreen(),
          PostScreen(),
          Center(
            child: Icon(Icons.notifications),
          ),
          Setting(),
        ],
        onPageChanged: (index) => {setState(() => _selectedNavIndex = index)},
        controller: _pc,
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(
      //   title: (screenTitle[_selectedNavIndex]),
      // ),
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            setState(() {
              notification.direction == ScrollDirection.reverse
                  ? showFAB = false
                  : showFAB = true;
            });
            return true;
          },
          child: _getPageView(),
        ),
      ),
      floatingActionButton: showFAB ? _indexPerFAB() : null,
      bottomNavigationBar: _getBottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
