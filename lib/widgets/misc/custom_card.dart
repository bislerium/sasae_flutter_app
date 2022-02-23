import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double elevation;
  final Color? shadowColor;
  final Color? cardColor;
  final EdgeInsets margin;

  const CustomCard({
    Key? key,
    required this.child,
    this.borderRadius = 20,
    this.elevation = 1,
    this.shadowColor,
    this.cardColor,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      shadowColor: shadowColor ?? Theme.of(context).colorScheme.shadow,
      color: cardColor ?? Theme.of(context).colorScheme.surface,
      margin: margin,
      child: child,
    );
  }
}
