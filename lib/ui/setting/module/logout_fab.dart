import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/auth/auth_screen.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class LogoutFAB extends StatefulWidget {
  const LogoutFAB({Key? key}) : super(key: key);

  @override
  State<LogoutFAB> createState() => _LogoutFABState();
}

class _LogoutFABState extends State<LogoutFAB> {
  bool _isLoading;

  _LogoutFABState() : _isLoading = false;

  @override
  Widget build(BuildContext context) => FloatingActionButton.large(
        onPressed: () async {
          if (_isLoading) return;
          showCustomDialog(
            context: context,
            title: 'Confirm Logout',
            content: 'Do it with passion or not at all.',
            okFunc: () async {
              Navigator.pop(context);
              if (!isInternetConnected(context)) return;
              setState(() => _isLoading = true);
              bool success =
                  await Provider.of<AuthProvider>(context, listen: false)
                      .logout();
              setState(() => _isLoading = false);
              if (success) {
                if (!mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AuthScreen.routeName, (Route<dynamic> route) => false);
              } else {
                showSnackBar(
                    context: context,
                    message: 'Unable to logout',
                    errorSnackBar: true);
              }
            },
          );
        },
        foregroundColor: Theme.of(context).colorScheme.onError,
        backgroundColor: Theme.of(context).colorScheme.error,
        tooltip: 'Logout',
        enableFeedback: true,
        child: _isLoading
            ? ButtomLoading(
                color: Theme.of(context).colorScheme.onError,
              )
            : const Icon(
                Icons.logout_rounded,
              ),
      );
}
