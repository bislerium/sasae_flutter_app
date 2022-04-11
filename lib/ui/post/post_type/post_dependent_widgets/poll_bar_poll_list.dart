import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';

class PollBarPollList extends StatelessWidget {
  final List<PollOptionModel> list;

  final Future<void> Function(int choice) handler;

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
                  onTap: () async => handler(e.id),
                  child: RoundedProgressBar(
                    percent: 0,
                    style: RoundedProgressBarStyle(
                      colorBorder: Theme.of(context).colorScheme.surface,
                      borderWidth: 0,
                      widthShadow: 0,
                      backgroundProgress:
                          Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    childCenter: Text(
                      e.option,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                )),
          )
          .toList(),
    );
  }
}
