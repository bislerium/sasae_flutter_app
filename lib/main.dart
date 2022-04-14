import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sasae_flutter_app/lib_color_schemes.g.dart';
import 'package:sasae_flutter_app/page_router.dart';
import 'package:sasae_flutter_app/providers/page_navigator_provider.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/providers/notification_provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/ui/auth/auth_screen.dart';
import 'package:sasae_flutter_app/ui/auth/register_screen.dart';
import 'package:sasae_flutter_app/ui/home_screen.dart';
import 'package:sasae_flutter_app/ui/ngo/ngo_profile_screen.dart';
import 'package:sasae_flutter_app/ui/image_view_screen.dart';
import 'package:sasae_flutter_app/ui/post/post_create_form_screen.dart';
import 'package:sasae_flutter_app/ui/post/post_type/normal_post_screen.dart';
import 'package:sasae_flutter_app/ui/post/post_type/poll_post_screen.dart';
import 'package:sasae_flutter_app/ui/post/post_type/request_post_screen.dart';
import 'package:sasae_flutter_app/ui/post/post_update_form_screen.dart';
import 'package:sasae_flutter_app/ui/profile/people_profile_edit_screen.dart';

late final AdaptiveThemeMode? deviceThemeMode;

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  deviceThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(
    MyApp(
      savedThemeMode: deviceThemeMode,
    ),
  );
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

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

    //-1 as placeholder for post_id in create mode (post-id not required)
    case (PostUpdateFormScreen.routeName):
      return PageTransition(
        child: PostUpdateFormScreen(
          postID: args['postID'],
        ),
        type: transitionType,
        settings: settings,
      );
    case (PostCreateFormScreen.routeName):
      return PageTransition(
        child: const PostCreateFormScreen(),
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
        create: (_) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => PageNavigatorProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => NotificationProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProfileSettingFABProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => DonationFABProvider(),
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
      ChangeNotifierProxyProvider<AuthProvider, PostUpdateProvider>(
        create: (context) => PostUpdateProvider(),
        update: (context, authP, profileP) =>
            PostUpdateProvider()..setAuthP = authP,
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
          child: AdaptiveTheme(
            light: ThemeData(
              colorScheme: lightColorScheme,
              textTheme: _textTheme(),
            ),
            dark: ThemeData(
              colorScheme: darkColorScheme,
              textTheme: _textTheme(),
            ),
            initial: widget.savedThemeMode ?? AdaptiveThemeMode.system,
            builder: (theme, darkTheme) => MaterialApp(
              navigatorKey: navigatorKey,
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('ne', 'NP'),
              ],
              localizationsDelegates: const [
                KhaltiLocalizations.delegate,
                FormBuilderLocalizations.delegate,
              ],
              theme: theme,
              darkTheme: darkTheme,
              title: 'Sasae',
              home: const PageRouter(),
              onGenerateRoute: (settings) => _screenRoutes(settings),
            ),
          ),
        );
      },
    );
  }
}
