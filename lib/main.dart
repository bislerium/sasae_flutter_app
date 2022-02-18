import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sasae_flutter_app/widgets/ngo/ngo_profile_screen.dart';
import './widgets/auth/register_screen.dart';
import './widgets/home_page.dart';
import './widgets/auth/login_screen.dart';
import './lib_color_schemes.g.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    var colorScheme = darkMode ? darkColorScheme : lightColorScheme;
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
        colorScheme: colorScheme,
        backgroundColor: colorScheme.background,
        primaryColor: colorScheme.primary,
        errorColor: colorScheme.error,
      ),
      home: HomePage(setDarkModeHandler: (value) => darkMode = value),
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        HomePage.routeName: (context) =>
            HomePage(setDarkModeHandler: (value) => darkMode = value),
      },
    );
  }
}
