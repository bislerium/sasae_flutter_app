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
    var textstyle = TextStyle(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    );
    return RoundedProgressBar(
      milliseconds: milliseconds,
      percent: percent.toDouble(),
      style: RoundedProgressBarStyle(
        colorBorder: Theme.of(context).colorScheme.surface,
        borderWidth: 2,
        widthShadow: 0,
        colorProgress: Theme.of(context).colorScheme.primaryContainer,
        backgroundProgress: Theme.of(context).colorScheme.surfaceVariant,
      ),
      childLeft: Text(
        title,
        style: textstyle,
      ),
      childRight: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isChoice)
            Icon(
              Icons.check_circle_rounded,
              size: 20,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '$percent%',
            style: textstyle,
          ),
        ],
      ),
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(25)),
    );
  }
}
