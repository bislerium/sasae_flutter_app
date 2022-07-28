import 'package:flutter/material.dart';

class CustomMaterialTile extends StatelessWidget {
  final Widget child;
  final double margin;
  final void Function()? func;
  final double elevation;
  final double? borderRadius;
  final Color? color;
  final Color? shadowColor;
  final Color? splashColor;

  const CustomMaterialTile({
    Key? key,
    required this.child,
    this.func,
    this.elevation = 0.0,
    this.borderRadius,
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
        color: color,
        shadowColor: shadowColor,
        shape: borderRadius == null
            ? null
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius!),
              ),
        child: InkWell(
          borderRadius: borderRadius == null
              ? null
              : BorderRadius.circular(borderRadius!),
          splashColor: splashColor,
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
