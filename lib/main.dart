import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/app_preference_provider.dart';
import 'package:sasae_flutter_app/widgets/post/post_form.dart';
import 'package:sasae_flutter_app/widgets/profile/user_profile_edit_screen.dart';
import './widgets/auth/register_screen.dart';
import './widgets/home_page.dart';
import './widgets/auth/login_screen.dart';
import './lib_color_schemes.g.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initialization();
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

Future<void> initialization() async {
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

TextTheme textTheme() => TextTheme(
      headline1: GoogleFonts.roboto(
          fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
      headline2: GoogleFonts.roboto(
          fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
      headline3: GoogleFonts.roboto(fontSize: 48, fontWeight: FontWeight.w400),
      headline4: GoogleFonts.roboto(
          fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      headline5: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
      headline6: GoogleFonts.roboto(
          fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      subtitle1: GoogleFonts.roboto(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
      subtitle2: GoogleFonts.roboto(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      bodyText1: GoogleFonts.roboto(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      bodyText2: GoogleFonts.roboto(
          fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      button: GoogleFonts.roboto(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
      caption: GoogleFonts.roboto(
          fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      overline: GoogleFonts.roboto(
          fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
    );

Route<dynamic>? argRoute(settings) {
  if (settings.name == UserProfileEditScreen.routeName) {
    final args = settings.arguments as Map;
    return MaterialPageRoute(
      builder: (context) {
        return UserProfileEditScreen(
          user: args['user'],
        );
      },
    );
  }
  assert(false, 'Need to implement ${settings.name}');
  return null;
}

Map<String, Widget Function(BuildContext)> nonArgRoute() => {
      LoginScreen.routeName: (context) => const LoginScreen(),
      RegisterScreen.routeName: (context) => const RegisterScreen(),
      HomePage.routeName: (context) => const HomePage(),
      PostForm.routeName: (context) => const PostForm(),
    };

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: "test_public_key_30e12814fed64afa9a7d4a92a2194aeb",
      builder: (context, navigatorKey) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => AppPreferenceProvider(),
            ),
          ],
          child: Consumer<AppPreferenceProvider>(
            builder: (context, appPreference, child) {
              var colorScheme =
                  appPreference.darkMode ? darkColorScheme : lightColorScheme;
              return MaterialApp(
                navigatorKey: navigatorKey,
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('ne', 'NP'),
                ],
                localizationsDelegates: const [
                  KhaltiLocalizations.delegate,
                  FormBuilderLocalizations.delegate,
                ],
                // debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  colorScheme: colorScheme,
                  backgroundColor: colorScheme.background,
                  primaryColor: colorScheme.primary,
                  errorColor: colorScheme.error,
                  textTheme: textTheme(),
                ),
                title: 'Sasae',
                home: const HomePage(),
                onGenerateRoute: (settings) => argRoute(settings),
                routes: nonArgRoute(),
              );
            },
          ),
        );
      },
    );
  }
}
