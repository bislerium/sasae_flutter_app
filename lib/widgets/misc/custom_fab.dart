import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? func;
  final Color? background;
  final Color? foreground;
  const CustomFAB({
    Key? key,
    required this.text,
    required this.icon,
    required this.func,
    this.background,
    this.foreground,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 60,
        child: FloatingActionButton.extended(
          heroTag: null,
          elevation: 3,
          onPressed: func,
          label: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          extendedPadding: const EdgeInsetsDirectional.all(25),
          icon: Icon(icon),
          backgroundColor: background ?? Theme.of(context).colorScheme.primary,
          foregroundColor:
              foreground ?? Theme.of(context).colorScheme.onPrimary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
        ),
      );
}
