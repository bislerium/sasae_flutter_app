import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sasae_flutter_app/page_router.dart';
import 'package:sasae_flutter_app/providers/page_navigator_provider.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/providers/notification_provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/scheme/font_scheme.dart';
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
import 'package:flex_color_scheme/flex_color_scheme.dart';

AdaptiveThemeMode? deviceThemeMode = AdaptiveThemeMode.system;

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  AdaptiveThemeMode? deviceThemeMode = await AdaptiveTheme.getThemeMode();
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
            light: FlexThemeData.light(
              scheme: FlexScheme.materialBaseline,
              surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
              blendLevel: 20,
              appBarOpacity: 0.95,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 20,
                blendOnColors: false,
                inputDecoratorIsFilled: false,
                inputDecoratorBorderType: FlexInputBorderType.underline,
              ),
              useMaterial3ErrorColors: true,
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true,
              // To use the playground font, add GoogleFonts package and uncomment
              // fontFamily: GoogleFonts.notoSans().fontFamily,
            ),
            dark: FlexThemeData.dark(
              scheme: FlexScheme.materialBaseline,
              surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
              blendLevel: 15,
              appBarStyle: FlexAppBarStyle.background,
              appBarOpacity: 0.90,
              // darkIsTrueBlack: true,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 30,
                inputDecoratorIsFilled: false,
                inputDecoratorBorderType: FlexInputBorderType.underline,
              ),
              useMaterial3ErrorColors: true,
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true,
              // To use the playground font, add GoogleFonts package and uncomment
              // fontFamily: GoogleFonts.notoSans().fontFamily,
            ),
            initial: widget.savedThemeMode ?? AdaptiveThemeMode.system,
            builder: (theme, darkTheme) => (MaterialApp(
              debugShowCheckedModeBanner: false,
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
              home: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor:
                      deviceThemeMode!.isLight ? Colors.white : Colors.black,
                  statusBarIconBrightness: deviceThemeMode!.isLight
                      ? Brightness.dark
                      : Brightness.light,
                  systemNavigationBarIconBrightness: deviceThemeMode!.isLight
                      ? Brightness.dark
                      : Brightness.light,
                ),
                child: PageRouter(),
              ),
              onGenerateRoute: (settings) => _screenRoutes(settings),
            )),
          ),
        );
      },
    );
  }
}
