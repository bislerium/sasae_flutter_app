import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PollBar extends StatelessWidget {
  final String title;
  final double percent;
  final bool isChoice;
  const PollBar({
    Key? key,
    required this.title,
    required this.percent,
    this.isChoice = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LinearPercentIndicator(
            animation: true,
            lineHeight: 40.0,
            animationDuration: 2000,
            isRTL: true,
            percent: percent,
            center: Text(
              title,
            ),
            barRadius: const Radius.circular(5),
            progressColor: isChoice
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.inversePrimary,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
        ),
        SizedBox(
          width: 50,
          child: Text(
            '${(percent * 100).toStringAsFixed(1)}%',
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ],
    );
  }
}
