import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/poll_bar.dart';

class PollCard extends StatefulWidget {
  final List<PollOption> list;
  final String? choice;

  const PollCard({Key? key, required this.list, this.choice}) : super(key: key);

  @override
  _PollCardState createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  int totalReaction() => widget.list
      .fold(0, (previousValue, element) => previousValue + element.numReaction);

  double percent(int count) => count.toDouble() / totalReaction().toDouble();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: widget.list
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: PollBar(
                    percent: percent(e.numReaction),
                    title: e.option,
                    isChoice: widget.choice == e.option,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
    ;
  }
}
