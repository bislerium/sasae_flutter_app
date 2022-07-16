import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/home_screen.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class LoginButton extends StatefulWidget {
  final GlobalKey<FormBuilderState> loginFormKey;
  final Cred credential;

  const LoginButton(
      {Key? key, required this.loginFormKey, required this.credential})
      : super(key: key);

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool _isLoading;
  late final AuthProvider _authP;

  _LoginButtonState() : _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authP = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('loginAB'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(14),
      ),
      onPressed: () async {
        if (_isLoading) return;
        if (!isInternetConnected(context)) return;
        final isValid = widget.loginFormKey.currentState!.validate();
        FocusScope.of(context).unfocus();
        if (isValid) {
          setState(() => _isLoading = true);
          await _authP.login(
            username: widget.credential.username,
            password: widget.credential.password,
          );
          setState(() => _isLoading = false);
          if (_authP.getIsAuth) {
            if (!mounted) return;
            await Navigator.of(context).pushNamedAndRemoveUntil(
                HomePage.routeName, (Route<dynamic> route) => false);
          } else {
            showSnackBar(
              context: context,
              message: 'Unable to login',
              errorSnackBar: true,
            );
          }
        }
      },
      child: _isLoading
          ? Padding(
              padding: const EdgeInsets.all(2.0),
              child: LoadingAnimationWidget.fallingDot(
                color: Theme.of(context).colorScheme.primary,
                size: 46,
              ),
            )
          : const Icon(
              Icons.navigate_next_rounded,
              size: 50,
            ),
    );
  }
}
