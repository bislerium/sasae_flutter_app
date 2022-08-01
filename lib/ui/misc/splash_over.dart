import 'package:flutter/material.dart';

class SplashOver extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final void Function()? onTap;
  final void Function()? onDoubleTap;

  const SplashOver({
    Key? key,
    required this.child,
    this.borderRadius,
    this.onTap,
    this.onDoubleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          child,
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: borderRadius ?? BorderRadius.circular(12),
                onTap: onTap,
                onDoubleTap: onDoubleTap,
              ),
            ),
          ),
        ],
      );
}
