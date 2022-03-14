import 'package:flutter/material.dart';
import 'profile/user_profile_screen.dart';
import './post/post_screen.dart';
import './ngo/ngo_screen.dart';
import './setting.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pc;
  int _selectedNavIndex;
  bool showFAB;

  _HomePageState()
      : _selectedNavIndex = 2,
        _pc = PageController(
          initialPage: 2,
        ),
        showFAB = true;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  Widget bottomNavBar() => NavigationBarTheme(
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
      body: SafeArea(
        child: _getPageView(),
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}
