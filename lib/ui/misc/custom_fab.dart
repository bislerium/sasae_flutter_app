import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/services/utilities.dart';

class CustomFAB extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? func;
  final Color? background;
  final Color? foreground;
  final String? tooltip;
  final bool requiresProfileVerification;
  final bool requiresInternetConnection;

  const CustomFAB(
      {Key? key,
      required this.text,
      required this.icon,
      required this.func,
      this.requiresInternetConnection = true,
      this.requiresProfileVerification = false,
      this.background,
      this.foreground,
      this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) => FloatingActionButton.large(
        heroTag: null,
        onPressed: () {
          if (requiresInternetConnection && !isInternetConnected(context)) {
            return;
          }
          if (requiresProfileVerification && !isProfileVerified(context)) {
            return;
          }
          func?.call();
        },
        tooltip: tooltip,
        backgroundColor: background,
        foregroundColor: foreground,
        child: Icon(icon),
      );
}
