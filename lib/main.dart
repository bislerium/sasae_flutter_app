import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sasae_flutter_app/lib_color_schemes.g.dart';
import 'package:sasae_flutter_app/providers/app_preference_provider.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/widgets/auth/auth_screen.dart';
import 'package:sasae_flutter_app/widgets/auth/register_screen.dart';
import 'package:sasae_flutter_app/widgets/home_page.dart';
import 'package:sasae_flutter_app/widgets/ngo/ngo_profile_screen.dart';
import 'package:sasae_flutter_app/widgets/image_view_screen.dart';
import 'package:sasae_flutter_app/widgets/post/post_form_screen.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/normal_post_screen.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/poll_post_screen.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/request_post_screen.dart';
import 'package:sasae_flutter_app/widgets/profile/people_profile_edit_screen.dart';
import 'package:sasae_flutter_app/widgets/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(backroundHandler);
  runApp(const MyApp());
}

Future<void> backroundHandler(RemoteMessage message) async {
  print(" This is message from background");
  print(message.notification!.title);
  print(message.notification!.body);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

TextTheme _textTheme() => TextTheme(
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

Route<dynamic>? _screenRoutes(RouteSettings settings) {
  final args = settings.arguments != null ? settings.arguments as Map : {};
  PageTransitionType transitionType = PageTransitionType.leftToRightWithFade;
  switch (settings.name) {
    case (AuthScreen.routeName):
      return PageTransition(
        child: const AuthScreen(),
        type: transitionType,
        settings: settings,
      );
    case (RegisterScreen.routeName):
      return PageTransition(
        child: const RegisterScreen(),
        type: transitionType,
        settings: settings,
      );
    case (HomePage.routeName):
      return PageTransition(
        child: const HomePage(),
        type: transitionType,
        settings: settings,
      );
    case (PostFormScreen.routeName):
      return PageTransition(
        child: const PostFormScreen(),
        type: transitionType,
        settings: settings,
      );
    case (PeopleProfileEditScreen.routeName):
      return PageTransition(
        child: const PeopleProfileEditScreen(),
        type: transitionType,
        settings: settings,
      );
    case (NGOProfileScreen.routeName):
      return PageTransition(
        child: NGOProfileScreen(
          ngoID: args['ngoID'],
        ),
        type: transitionType,
        settings: settings,
      );
    case (NormalPostScreen.routeName):
      return PageTransition(
        child: NormalPostScreen(
          postID: args['postID'],
        ),
        type: transitionType,
        settings: settings,
      );
    case (PollPostScreen.routeName):
      return PageTransition(
        child: PollPostScreen(
          postID: args['postID'],
        ),
        type: transitionType,
        settings: settings,
      );
    case (RequestPostScreen.routeName):
      return PageTransition(
        child: RequestPostScreen(
          postID: args['postID'],
        ),
        type: transitionType,
        settings: settings,
      );
    case (ImageViewScreen.routeName):
      return PageTransition(
        child: ImageViewScreen(
          title: args['title'],
          imageURL: args['imageURL'],
        ),
        type: PageTransitionType.fade,
        settings: settings,
      );
    default:
      assert(false, 'Need to implement ${settings.name}');
      return null;
  }
}

List<SingleChildWidget> _providers() => [
      ChangeNotifierProvider(
        create: (_) => AppPreferenceProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProfileSettingFABProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => PostFABProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LogoutFABProvider(),
      ),
      ChangeNotifierProxyProvider<AuthProvider, NGOProvider>(
        create: (context) => NGOProvider(),
        update: (context, authP, ngoP) => NGOProvider()..setAuthP = authP,
      ),
      ChangeNotifierProxyProvider<AuthProvider, PostProvider>(
        create: (context) => PostProvider(),
        update: (context, authP, profileP) => PostProvider()..setAuthP = authP,
      ),
      ChangeNotifierProxyProvider<AuthProvider, PostCreateProvider>(
        create: (context) => PostCreateProvider(),
        update: (context, authP, profileP) =>
            PostCreateProvider()..setAuthP = authP,
      ),
      ChangeNotifierProxyProvider<AuthProvider, NormalPostProvider>(
        create: (context) => NormalPostProvider(),
        update: (context, authP, normalPostP) =>
            NormalPostProvider()..setAuthP = authP,
      ),
      ChangeNotifierProxyProvider<AuthProvider, PollPostProvider>(
        create: (context) => PollPostProvider(),
        update: (context, authP, pollPostP) =>
            PollPostProvider()..setAuthP = authP,
      ),
      ChangeNotifierProxyProvider<AuthProvider, RequestPostProvider>(
        create: (context) => RequestPostProvider(),
        update: (context, authP, requestP) =>
            RequestPostProvider()..setAuthP = authP,
      ),
      ChangeNotifierProxyProvider<AuthProvider, PeopleProvider>(
        create: (context) => PeopleProvider(),
        update: (context, authP, profileP) =>
            PeopleProvider()..setAuthP = authP,
      ),
      ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
        create: (context) => ProfileProvider(),
        update: (context, authP, profileP) =>
            ProfileProvider()..setAuthP = authP,
      ),
    ];

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: "test_public_key_30e12814fed64afa9a7d4a92a2194aeb",
      builder: (context, navigatorKey) {
        return MultiProvider(
          providers: _providers(),
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
                  textTheme: _textTheme(),
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
                onGenerateRoute: (settings) => _screenRoutes(settings),
              );
            },
          ),
        );
      },
    );
  }
}
