import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/ui/auth/auth_screen.dart';
import 'package:sasae_flutter_app/ui/home_screen.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';

class PageRouter extends StatefulWidget {
  const PageRouter({Key? key}) : super(key: key);

  @override
  State<PageRouter> createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {
  late final Future<void> _autoLoginFuture;
  late final AuthProvider _authP;

  @override
  void initState() {
    super.initState();
    _autoLoginFuture = tryAutoLogin();
  }

  Future<void> tryAutoLogin() async {
    _authP = Provider.of<AuthProvider>(context, listen: false);
    await _authP.tryAutoLogin();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _autoLoginFuture,
      builder: (ctx, authSnapshot) =>
          authSnapshot.connectionState == ConnectionState.waiting
              ? const CustomLoading()
              : _authP.isAuth
                  ? const HomePage()
                  : const AuthScreen(),
    );
  }
}