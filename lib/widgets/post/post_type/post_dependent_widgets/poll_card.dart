import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/poll_bar.dart';

class PollCard extends StatefulWidget {
  final List<PollOption> list;
  final String? choice;

  const PollCard({Key? key, required this.list, this.choice}) : super(key: key);

  @override
  _PollCardState createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  String? _choice;
  late int _totalReaction;

  @override
  void initState() {
    super.initState();
    _choice = widget.choice;
    totalReaction();
  }

  int totalReaction() => _totalReaction = widget.list
      .fold(0, (previousValue, element) => previousValue + element.numReaction);

  double percent(int count) =>
      turnicate((count / _totalReaction) * 100).toDouble();

  Future<void> setChoice(String choice) async {
    var search = widget.list.indexWhere((element) => element.option == choice);
    widget.list[search].numReaction++;
    totalReaction();
    setState(() {
      _choice = choice;
    });
  }

  List<Widget> pollReveal() => widget.list
      .map(
        (e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: PollBar(
            percent: percent(e.numReaction),
            title: e.option,
            isChoice: _choice == e.option,
          ),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Polls:',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (_choice == null)
              ...widget.list
                  .map(
                    (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: GestureDetector(
                          onTap: () => setChoice(e.option),
                          child: RoundedProgressBar(
                            percent: 0,
                            style: RoundedProgressBarStyle(
                              borderWidth: 0,
                              widthShadow: 0,
                              backgroundProgress: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                            ),
                            childCenter: Text(
                              e.option,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        )),
                  )
                  .toList()
            else
              ...pollReveal()
          ],
        ),
      ),
    );
    ;
  }
}
