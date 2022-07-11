import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sasae_flutter_app/page_router.dart';
import 'package:sasae_flutter_app/providers/internet_connection_provider.dart';
import 'package:sasae_flutter_app/providers/page_navigator_provider.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/providers/notification_provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/providers/theme_provider.dart';
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

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
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
        create: (_) => InternetConnetionProvider(),
      ),
      // ChangeNotifierProvider(
      //   create: (_) => ThemeProvider(),
      // ),
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
        create: (_) => NotificationActionFABProvider(),
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

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Provider.of<ThemeProvider>(context, listen: false).fetchTheme();
  }

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: "test_public_key_30e12814fed64afa9a7d4a92a2194aeb",
      builder: (context, navigatorKey) {
        return MultiProvider(
          providers: _providers(),
          child: Builder(builder: (context) {
            Color brandingColor =
                Provider.of<ThemeProvider>(context).getBrandingColor;
            return DynamicColorBuilder(
                builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
              ColorScheme lightColorScheme;
              ColorScheme darkColorScheme;

              if (lightDynamic != null && darkDynamic != null) {
                // On Android S+ devices, use the provided dynamic color scheme.
                // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
                lightColorScheme = lightDynamic.harmonized();
                // (Optional) Customize the scheme as desired. For example, one might
                // want to use a brand color to override the dynamic [ColorScheme.secondary].
                lightColorScheme =
                    lightColorScheme.copyWith(secondary: brandingColor);

                // Repeat for the dark color scheme.
                darkColorScheme = darkDynamic.harmonized();
                darkColorScheme =
                    darkColorScheme.copyWith(secondary: brandingColor);
              } else {
                // Otherwise, use fallback schemes.
                lightColorScheme = ColorScheme.fromSeed(
                  seedColor: brandingColor,
                );
                darkColorScheme = ColorScheme.fromSeed(
                  seedColor: brandingColor,
                  brightness: Brightness.dark,
                );
              }
              return BetterFeedback(
                localeOverride: const Locale('en'),
                mode: FeedbackMode.draw,
                pixelRatio: 1,
                localizationsDelegates: [
                  GlobalFeedbackLocalizationsDelegate(),
                ],
                child: MaterialApp(
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
                  theme: ThemeData(
                    visualDensity: VisualDensity.comfortable,
                    platform: TargetPlatform.android,
                    colorScheme: lightColorScheme,
                    useMaterial3: true,
                    chipTheme: ChipThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    fontFamily: GoogleFonts.robotoFlex().fontFamily,
                    typography: Typography.material2021(),
                  ),
                  darkTheme: ThemeData(
                    visualDensity: VisualDensity.comfortable,
                    platform: TargetPlatform.android,
                    colorScheme: darkColorScheme,
                    useMaterial3: true,
                    chipTheme: ChipThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    fontFamily: GoogleFonts.robotoFlex().fontFamily,
                    typography: Typography.material2021(),
                  ),
                  themeMode: Provider.of<ThemeProvider>(context).getThemeMode,
                  title: 'Sasae',
                  home: const PageRouter(),
                  onGenerateRoute: (settings) => _screenRoutes(settings),
                ),
              );
            });
          }),
        );
      },
    );
  }
}
