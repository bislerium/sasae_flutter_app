import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import './profile/user_profile.dart';
import './auth/login_screen.dart';
import './post/post_screen.dart';
import './ngo/ngo_screen.dart';
import './setting.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  final void Function(bool) setDarkModeHandler;

  const HomePage({Key? key, required this.setDarkModeHandler})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pc;
  int _selectedNavIndex;
  List<String> screenTitle;

  _HomePageState()
      : _selectedNavIndex = 1,
        _pc = PageController(
          initialPage: 1,
        ),
        screenTitle = ['NGO', 'Feed', 'Notification', 'Profile', 'Setting'];

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  ListTile getPostModalItem(BuildContext ctx, IconData icon, String title,
      String subtitle, VoidCallback func) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: Theme.of(ctx).primaryColor,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: func,
    );
  }

  void showModalSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getPostModalItem(_, Icons.file_present_sharp, 'Normal Post',
                  'Attach an Image!', () {
                Navigator.pop(context);
              }),
              getPostModalItem(_, Icons.poll, 'Poll Post', 'Poll the Options!',
                  () {
                Navigator.pop(context);
              }),
              getPostModalItem(
                  _, Icons.help_center, 'Request Post', 'Request to Change!',
                  () {
                Navigator.pop(context);
              }),
            ],
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
    );
  }

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

  Widget? _fabPerNavIndex() {
    switch (_selectedNavIndex) {
      case 1:
        {
          return SizedBox(
            height: 60,
            width: 120,
            child: getFloatingActionButton(
              text: 'Post',
              buttonColor: Theme.of(context).colorScheme.inversePrimary,
              icon: Icons.post_add,
              function: () => showModalSheet(context),
              foreground: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          );
        }
      case 4:
        {
          return getFloatingActionButton(
            text: 'Logout',
            icon: Icons.logout,
            function: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 3,
                title: const Text('Logout?'),
                content: const Text('"Do it with Passion or Not at all"'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(LoginScreen.routeName,
                            (Route<dynamic> route) => false),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              barrierDismissible: false,
            ),
            foreground: Theme.of(context).colorScheme.onError,
            buttonColor: Theme.of(context).colorScheme.error,
          );
        }
      default:
        {
          return null;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: (screenTitle[_selectedNavIndex]),
      ),
      body: SafeArea(
        child: PageView(
          children: [
            const NGOScreen(),
            const PostScreen(),
            const Center(
              child: Icon(Icons.notifications),
            ),
            const UserProfile(),
            Setting(setDarkModeHandler: widget.setDarkModeHandler),
          ],
          onPageChanged: (index) => {setState(() => _selectedNavIndex = index)},
          controller: _pc,
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        ),
      ),
      floatingActionButton: _fabPerNavIndex(),
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
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
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
      ),
    );
  }
}
