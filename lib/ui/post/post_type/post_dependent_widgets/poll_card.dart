import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/poll_bar_poll_list.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/poll_bar_reveal_list.dart';

class PollCard extends StatefulWidget {
  final List<PollOptionModel> list;
  final int? choice;
  final DateTime? endsOn;
  const PollCard({Key? key, required this.list, this.choice, this.endsOn})
      : super(key: key);

  @override
  State<PollCard> createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  int? _choice;

  @override
  void initState() {
    super.initState();
    _choice = widget.choice;
  }

  Future<void> setChoice(int choice) async {
    var option = widget.list.firstWhere((element) => element.id == choice);
    bool success = await Provider.of<PollPostProvider>(context, listen: false)
        .pollTheOption(optionID: choice);
    if (success) {
      if (!mounted) return;
      option.reaction.add(
          Provider.of<AuthProvider>(context, listen: false).auth!.profileID);
      setState(() {
        _choice = choice;
      });
    } else {
      showSnackBar(
        context: context,
        message: 'Something went wrong!',
        errorSnackBar: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: EdgeInsets.zero,
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
                    backgroundColor: DateTime.now().isAfter(widget.endsOn!)
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                    label: Text(DateFormat.yMMMEd().format(widget.endsOn!),
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            color: DateTime.now().isAfter(widget.endsOn!)
                                ? Theme.of(context).colorScheme.onError
                                : Theme.of(context).colorScheme.onSecondary)),
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
                list: widget.list,
                pollCallBack: setChoice,
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
