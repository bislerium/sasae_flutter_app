import 'package:flutter/material.dart';

class CustomMaterialTile extends StatelessWidget {
  final Widget child;
  final double margin;
  final void Function()? func;
  final double elevation;
  final double borderRadius;
  final Color? color;
  final Color? shadowColor;
  final Color? splashColor;

  const CustomMaterialTile({
    Key? key,
    required this.child,
    this.func,
    this.elevation = 1,
    this.borderRadius = 10,
    this.color,
    this.shadowColor,
    this.splashColor,
    this.margin = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      child: Material(
        elevation: elevation,
        color: color ?? Theme.of(context).colorScheme.surfaceVariant,
        shadowColor: shadowColor ?? Theme.of(context).colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor:
              splashColor ?? Theme.of(context).colorScheme.inversePrimary,
          onTap: () {
            if (func != null) {
              func!();
            }
          },
          child: child,
        ),
      ),
    );
  }
}
