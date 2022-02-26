import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';

class PollBar extends StatelessWidget {
  final String title;
  final double percent;
  final bool isChoice;
  final int milliseconds;
  const PollBar({
    Key? key,
    required this.title,
    required this.percent,
    this.milliseconds = 1000,
    this.isChoice = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var progress = isChoice
        ? Theme.of(context).colorScheme.inversePrimary
        : Theme.of(context).colorScheme.secondaryContainer;
    var textstyle = TextStyle(
      color: isChoice
          ? Theme.of(context).colorScheme.onPrimaryContainer
          : Theme.of(context).colorScheme.onSecondaryContainer,
      fontWeight: isChoice ? FontWeight.bold : null,
    );
    return RoundedProgressBar(
      milliseconds: milliseconds,
      percent: percent.toDouble(),
      style: RoundedProgressBarStyle(
        colorBorder: Theme.of(context).colorScheme.surface,
        borderWidth: 0,
        widthShadow: 0,
        colorProgress: progress,
        backgroundProgress: Theme.of(context).colorScheme.surface,
      ),
      childLeft: Text(
        title,
        style: textstyle,
      ),
      childRight: Text(
        '$percent%',
        style: textstyle,
      ),
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(25)),
    );
  }
}
