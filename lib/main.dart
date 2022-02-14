import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sasae_flutter_app/widgets/post/post_screen.dart';
import 'widgets/ngo/ngo_screen.dart';
import './screens/login_screen.dart';
import './widgets/setting.dart';

void main() {
  FlutterNativeSplash.removeAfter(initialization);
  runApp(const MyApp());
}

void initialization(BuildContext context) async {
  // This is where you can initialize the resources needed by your app while
  // the splash screen is displayed.  Remove the following example because
  // delaying the user experience is a bad design practice!
  // ignore_for_file: avoid_print
  print('ready in 3...');
  await Future.delayed(const Duration(seconds: 1));
  print('ready in 2...');
  await Future.delayed(const Duration(seconds: 1));
  print('ready in 1...');
  await Future.delayed(const Duration(seconds: 1));
  print('go!');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sasae',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
        cardColor: Colors.white,
        // colorScheme: const ColorScheme.light(),
        scaffoldBackgroundColor: const Color.fromRGBO(238, 235, 242, 1),
      ),
      home: const MyHomePage(),
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        MyHomePage.routeName: (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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

class _MyHomePageState extends State<MyHomePage> {
  void showModalSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            getPostModalItem(
                _, Icons.file_present_sharp, 'Normal Post', 'Attach an Image!',
                () {
              Navigator.pop(context);
            }),
            getPostModalItem(_, Icons.poll, 'Poll Post', 'Poll the Options!',
                () {
              Navigator.pop(context);
            }),
            getPostModalItem(
                _, Icons.help_center, 'Request Post', 'Request to Change!', () {
              Navigator.pop(context);
            }),
          ],
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(0),
            bottomLeft: Radius.circular(0)),
      ),
    );
  }

  var _selectedNavIndex = 1;

  List<Map<String, dynamic>> get screens => [
        {
          'widget': const Center(
            child: NGOs(),
          ),
          'title': 'NGO',
        },
        {
          'widget': const PostListScreen(),
          'title': 'Feed',
        },
        {
          'widget': const Center(
            child: Icon(Icons.notifications),
          ),
          'title': 'Notification',
        },
        {
          'widget': const Center(
            child: Icon(Icons.person),
          ),
          'title': 'Profile',
        },
        {
          'widget': const Setting(),
          'title': 'Setting',
        }
      ];

  FloatingActionButton getFloatingActionButton(
      {required String text,
      required IconData icon,
      required VoidCallback function,
      Color? buttonColor}) {
    return FloatingActionButton.extended(
      onPressed: function,
      label: Text(text),
      icon: Icon(icon),
      backgroundColor: buttonColor,
      shape: const StadiumBorder(),
    );
  }

  FloatingActionButton? _fabPerNavIndex() {
    switch (_selectedNavIndex) {
      case 1:
        {
          return getFloatingActionButton(
            text: 'Post',
            icon: Icons.post_add,
            function: () => showModalSheet(context),
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
                title: const Text('Logout?'),
                content: const Text('"Do it with Passion or Not at all"'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(LoginScreen.routeName,
                            (Route<dynamic> route) => false),
                    child: const Text('OK'),
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
            buttonColor: Colors.red,
          );
        }
      default:
        {
          return null;
        }
    }
  }

  PageController? _pc;

  @override
  void initState() {
    super.initState();
    _pc = PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(screens[_selectedNavIndex]['title']),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: PageView(
          children: screens.map((e) => e['widget'] as Widget).toList(),
          onPageChanged: (index) => {setState(() => _selectedNavIndex = index)},
          controller: _pc,
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        ),
      ),
      floatingActionButton: _fabPerNavIndex(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'NGO',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedNavIndex, //New
        onTap: (index) => {
          setState(() {
            _selectedNavIndex = index;
            _pc!.animateToPage(
              _selectedNavIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          })
        },
      ),
    );
  }
}
