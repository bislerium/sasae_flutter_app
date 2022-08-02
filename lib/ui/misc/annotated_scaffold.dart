import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnnotatedScaffold extends StatelessWidget {
  final Widget child;
  final Color? statusBarColor;
  final Color? systemNavigationBarColor;
  final Brightness? statusBarIconBrightness;
  final Brightness? systemNavigationBarIconBrightness;
  const AnnotatedScaffold({
    Key? key,
    required this.child,
    this.statusBarColor,
    this.systemNavigationBarColor,
    this.statusBarIconBrightness,
    this.systemNavigationBarIconBrightness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? Colors.transparent,
        systemNavigationBarColor: systemNavigationBarColor ??
            Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness: statusBarIconBrightness ??
            (Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light),
        systemNavigationBarIconBrightness: systemNavigationBarIconBrightness ??
            (Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light),
      ),
      child: child,
    );
  }
}
