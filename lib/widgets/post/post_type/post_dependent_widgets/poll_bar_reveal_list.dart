import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/poll_bar.dart';

class PollBarRevealList extends StatelessWidget {
  final List<PollOption> list;
  final String? choice;

  const PollBarRevealList({Key? key, required this.list, this.choice})
      : super(key: key);

  int totalReaction() => list.fold(
      0, (previousValue, element) => previousValue + element.numReaction);

  double percent(int count, int toalReaction) =>
      turnicate((count / toalReaction) * 100).toDouble();

  @override
  Widget build(BuildContext context) {
    int reactions = totalReaction();
    return Column(
      children: list
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: PollBar(
                percent: percent(e.numReaction, reactions),
                title: e.option,
                isChoice: choice == e.option,
              ),
            ),
          )
          .toList(),
    );
  }
}