import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sasae_flutter_app/lib_color_schemes.g.dart';
import 'package:sasae_flutter_app/providers/app_preference_provider.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/widgets/auth/auth_screen.dart';
import 'package:sasae_flutter_app/widgets/auth/register_screen.dart';
import 'package:sasae_flutter_app/widgets/home_page.dart';
import 'package:sasae_flutter_app/widgets/post/post_form.dart';
import 'package:sasae_flutter_app/widgets/profile/user_profile_edit_screen.dart';
import 'package:sasae_flutter_app/widgets/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
      AuthScreen.routeName: (context) => const AuthScreen(),
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
            ChangeNotifierProvider(
              create: (_) => AuthProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => NGOProvider(),
            ),
          ],
          child: Consumer2<AppPreferenceProvider, AuthProvider>(
            builder: (context, appPreference, auth, child) {
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
                home: FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : auth.isAuth
                              ? const HomePage()
                              : const AuthScreen(),
                ),
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
