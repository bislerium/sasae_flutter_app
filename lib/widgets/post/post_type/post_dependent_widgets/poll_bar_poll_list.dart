import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';

class PollBarPollList extends StatelessWidget {
  final List<String> list;

  final Future<void> Function(String choice) handler;

  const PollBarPollList({Key? key, required this.list, required this.handler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: list
          .map(
            (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: GestureDetector(
                  onTap: () => handler(e),
                  child: RoundedProgressBar(
                    percent: 0,
                    style: RoundedProgressBarStyle(
                      borderWidth: 0,
                      widthShadow: 0,
                      backgroundProgress:
                          Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    childCenter: Text(
                      e,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                )),
          )
          .toList(),
    );
  }
}
