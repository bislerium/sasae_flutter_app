// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
// import 'package:flutter/material.dart';

// PersistentTabController _controller;

// _controller = PersistentTabController(initialIndex: 0);

// class BottomNavBar extends StatelessWidget {
  
//   final List<Widget> screens;

//   BottomNavBar(this.screens, );
  
//   List<PersistentBottomNavBarItem> _navBarsItems() {
//         return [
//             PersistentBottomNavBarItem(
//                 icon: const Icon(Icons.home),
//                 title: ("Home"),
//                 activeColorPrimary: Colors.blue,
//                 inactiveColorPrimary: Colors.grey,
//             ),
//             PersistentBottomNavBarItem(
//                 icon: Icon(Icons.settings),
//                 title: ("Settings"),
//                 activeColorPrimary: Colors.blue,
//                 inactiveColorPrimary: Colors.grey,
//             ),
//         ];
//     }

//   @override
//   Widget build(BuildContext context) {
//     return PersistentTabView(
//         context,
//         controller: _controller,
//         screens: [
//           Scaffold(body: const Text ('wowo'),),
//           Scaffold(body: const Text ('wowo'),),
//         ],
//         items: _navBarsItems(),
//         confineInSafeArea: true,
//         backgroundColor: Colors.white, // Default is Colors.white.
//         handleAndroidBackButtonPress: true, // Default is true.
//         resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
//         stateManagement: true, // Default is true.
//         hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
//         decoration: NavBarDecoration(
//           borderRadius: BorderRadius.circular(10.0),
//           colorBehindNavBar: Colors.white,
//         ),
//         popAllScreensOnTapOfSelectedTab: true,
//         popActionScreens: PopActionScreensType.all,
//         itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
//           duration: Duration(milliseconds: 200),
//           curve: Curves.ease,
//         ),
//         screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
//           animateTabTransition: true,
//           curve: Curves.ease,
//           duration: Duration(milliseconds: 200),
//         ),
//         navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
//     );
//   }
// }