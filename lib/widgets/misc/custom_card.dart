import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final double elevation;
  final Color? shadowColor;
  final Color? cardColor;
  final EdgeInsets margin;

  const CustomCard({
    Key? key,
    required this.child,
    this.borderRadius,
    this.elevation = 0,
    this.shadowColor,
    this.cardColor,
    this.margin = const EdgeInsets.symmetric(vertical: 6),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: borderRadius == null
          ? null
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius!),
            ),
      shadowColor: shadowColor,
      color: cardColor,
      margin: margin,
      child: child,
    );
  }
}
