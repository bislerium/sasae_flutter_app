import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ScreenLoading extends StatelessWidget {
  const ScreenLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.prograssiveDots(
        color: Theme.of(context).colorScheme.primary,
        size: 80,
      ),
    );
  }
}

class ButtomLoading extends StatelessWidget {
  final double size;
  final Color? color;
  const ButtomLoading({Key? key, this.size = 50.0, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.horizontalRotatingDots(
      color: color ?? Theme.of(context).colorScheme.primary,
      size: size,
    );
  }
}
