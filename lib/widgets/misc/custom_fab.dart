import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback func;
  final Color? background;
  final Color? foreground;
  final double height;
  final double width;

  const CustomFAB({
    Key? key,
    required this.text,
    required this.icon,
    required this.func,
    this.background,
    this.foreground,
    this.height = 60,
    this.width = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: FloatingActionButton.extended(
        elevation: 3,
        onPressed: func,
        label: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: Icon(icon),
        backgroundColor: background ?? Theme.of(context).colorScheme.primary,
        foregroundColor: foreground ?? Theme.of(context).colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
      ),
    );
  }
}
