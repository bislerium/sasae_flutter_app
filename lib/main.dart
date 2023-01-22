import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sasae_flutter_app/page_router.dart';
import 'package:sasae_flutter_app/providers/internet_connection_provider.dart';
import 'package:sasae_flutter_app/providers/map_provider.dart';
import 'package:sasae_flutter_app/providers/page_navigator_provider.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/visibility_provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/providers/notification_provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/providers/startup_provider.dart';
import 'package:sasae_flutter_app/ui/auth/auth_screen.dart';
import 'package:sasae_flutter_app/ui/auth/register_screen.dart';
import 'package:sasae_flutter_app/ui/home_screen.dart';
import 'package:sasae_flutter_app/ui/geolocation/map_screen.dart';
import 'package:sasae_flutter_app/ui/ngo/ngo_profile_screen.dart';
import 'package:sasae_flutter_app/image_view_screen.dart';
import 'package:sasae_flutter_app/ui/post/form/post_create_form_screen.dart';
import 'package:sasae_flutter_app/ui/post/form/post_update_form_screen.dart';
import 'package:sasae_flutter_app/ui/post/type/normal_post_screen.dart';
import 'package:sasae_flutter_app/ui/post/type/poll_post_screen.dart';
import 'package:sasae_flutter_app/ui/post/type/request_post_screen.dart';
import 'package:sasae_flutter_app/ui/profile/people_profile_edit_screen.dart';
import 'package:wiredash/wiredash.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider<StartupConfigProvider>(
      create: (context) => StartupConfigProvider(),
      child: const StartupResourceLoader(),
    ),
  );
}

////////////////////////////////////////////////////////////////////////////////

class StartupResourceLoader extends StatefulWidget {
  const StartupResourceLoader({Key? key}) : super(key: key);

  @override
  State<StartupResourceLoader> createState() => _StartupResourceLoaderState();
}

class _StartupResourceLoaderState extends State<StartupResourceLoader> {
  late final Future fetchStartupConfigFUTURE;

  @override
  void initState() {
    fetchStartupConfigFUTURE =
        Provider.of<StartupConfigProvider>(context, listen: false)
            .fetchStartupConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: fetchStartupConfigFUTURE,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          return const MyApp();
        },
      );
}

////////////////////////////////////////////////////////////////////////////////

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final List<SingleChildWidget> _providers;

  @override
  void initState() {
    super.initState();
    _providers = [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => InternetConnectionProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => MapProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => CompassProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => MapLauncherProvider(),
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
        create: (_) => NotificationActionFABProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => NavigationBarProvider(),
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
      ChangeNotifierProxyProvider<AuthProvider, NGOProfilePostProvider>(
        create: (context) => NGOProfilePostProvider(),
        update: (context, authP, profileP) =>
            NGOProfilePostProvider()..setAuthP = authP,
      ),
      ChangeNotifierProxyProvider<AuthProvider, UserProfilePostProvider>(
        create: (context) => UserProfilePostProvider(),
        update: (context, authP, profileP) =>
            UserProfilePostProvider()..setAuthP = authP,
      ),
    ];
  }

  @override
  void dispose() {
    Provider.of<StartupConfigProvider>(context)
        .getShakeDetector
        ?.stopListening();
    super.dispose();
  }

  ThemeData getThemeData({required ColorScheme colorScheme}) => ThemeData(
        visualDensity: VisualDensity.comfortable,
        platform: TargetPlatform.android,
        colorScheme: colorScheme,
        useMaterial3: true,
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
          ),
        ),
        fontFamily: GoogleFonts.robotoFlex().fontFamily,
        typography: Typography.material2021(),
      );

  Route<dynamic>? _screenRoutes(RouteSettings settings) {
    final args = settings.arguments != null ? settings.arguments as Map : {};
    switch (settings.name) {
      case (AuthScreen.routeName):
        return MaterialPageRoute(
          builder: (context) => const AuthScreen(),
          settings: settings,
        );
      case (RegisterScreen.routeName):
        return MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
          settings: settings,
        );
      case (HomePage.routeName):
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
          settings: settings,
        );
      case (MapScreen.routeName):
        return MaterialPageRoute(
          builder: (context) => MapScreen(
            latitude: args['lat'],
            longitude: args['lng'],
            markerTitle: args['title'],
          ),
          settings: settings,
        );
      //-1 as placeholder for post_id in create mode (post-id not required)
      case (PostUpdateFormScreen.routeName):
        return MaterialPageRoute(
          builder: (context) => PostUpdateFormScreen(
            postID: args['postID'],
          ),
          settings: settings,
        );
      case (PostCreateFormScreen.routeName):
        return MaterialPageRoute(
          builder: (context) => const PostCreateFormScreen(),
          settings: settings,
        );
      case (PeopleProfileEditScreen.routeName):
        return MaterialPageRoute(
          builder: (context) => const PeopleProfileEditScreen(),
          settings: settings,
        );
      case (NGOProfileScreen.routeName):
        return MaterialPageRoute(
          builder: (context) => NGOProfileScreen(
            ngoID: args['ngoID'],
          ),
          settings: settings,
        );
      case (NormalPostScreen.routeName):
        return MaterialPageRoute(
          builder: (context) => NormalPostScreen(
            postID: args['postID'],
          ),
          settings: settings,
        );
      case (PollPostScreen.routeName):
        return MaterialPageRoute(
          builder: (context) {
            return PollPostScreen(
              postID: args['postID'],
            );
          },
          settings: settings,
        );
      case (RequestPostScreen.routeName):
        return MaterialPageRoute(
          builder: (context) => RequestPostScreen(
            postID: args['postID'],
          ),
          settings: settings,
        );
      case (ImageViewScreen.routeName):
        return MaterialPageRoute(
          builder: (context) => ImageViewScreen(
            title: args['title'],
            imageURL: args['imageURL'],
          ),
          settings: settings,
        );
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: "test_public_key_3b3e8b05ec734b83ab799166196c98e8",
      builder: (context, navigatorKey) {
        return MultiProvider(
          providers: _providers,
          child: Builder(builder: (context) {
            Color brandingColor =
                Provider.of<StartupConfigProvider>(context).getBrandingColor;
            return DynamicColorBuilder(
                builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
              ColorScheme lightColorScheme;
              ColorScheme darkColorScheme;
              if (lightDynamic != null && darkDynamic != null) {
                lightColorScheme = lightDynamic.harmonized();
                darkColorScheme = darkDynamic.harmonized();
              } else {
                lightColorScheme = ColorScheme.fromSeed(
                  seedColor: brandingColor,
                );
                darkColorScheme = ColorScheme.fromSeed(
                  seedColor: brandingColor,
                  brightness: Brightness.dark,
                );
              }
              return Wiredash(
                projectId: 'sasae-u9orerr',
                secret: 'xbVZHRT4V29O3x6ttzIcDZ-7HUL569yo',
                padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
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
                  theme: getThemeData(colorScheme: lightColorScheme),
                  darkTheme: getThemeData(colorScheme: darkColorScheme),
                  themeMode:
                      Provider.of<StartupConfigProvider>(context).getThemeMode,
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
