import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/poll_bar_poll_list.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/poll_bar_reveal_list.dart';

class PollCard extends StatefulWidget {
  final List<PollOption> list;
  final String? choice;
  final DateTime? endsOn;
  const PollCard({Key? key, required this.list, this.choice, this.endsOn})
      : super(key: key);

  @override
  _PollCardState createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  String? _choice;

  @override
  void initState() {
    super.initState();
    _choice = widget.choice;
  }

  Future<void> setChoice(String choice) async {
    var search = widget.list.indexWhere((element) => element.option == choice);
    setState(() {
      widget.list[search].numReaction++;
      _choice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Polls:',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                if (widget.endsOn != null)
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      DateFormat.yMMMEd().format(widget.endsOn!),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            if (_choice == null &&
                (widget.endsOn == null ||
                    DateTime.now().isBefore(widget.endsOn!)))
              PollBarPollList(
                list: widget.list.map((e) => e.option).toList(),
                handler: setChoice,
              )
            else
              PollBarRevealList(
                list: widget.list,
                choice: _choice,
              ),
          ],
        ),
      ),
    );
  }
}
