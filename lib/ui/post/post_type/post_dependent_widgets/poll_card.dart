import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/futter_polls.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class PollCard extends StatefulWidget {
  final PollModel pollModel;
  const PollCard({Key? key, required this.pollModel}) : super(key: key);

  @override
  State<PollCard> createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  @override
  Widget build(BuildContext context) {
    var pollBackgroundColor = Theme.of(context).colorScheme.surfaceVariant;
    var pollTextStyle = Theme.of(context).textTheme.titleSmall!.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        );
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
                if (widget.pollModel.endsOn != null)
                  Chip(
                    backgroundColor:
                        DateTime.now().isAfter(widget.pollModel.endsOn!)
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary,
                    label: Text(
                      DateFormat.yMMMEd().format(widget.pollModel.endsOn!),
                      style: Theme.of(context).textTheme.caption?.copyWith(
                          color:
                              DateTime.now().isAfter(widget.pollModel.endsOn!)
                                  ? Theme.of(context).colorScheme.onError
                                  : Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FlutterPolls(
              pollId: widget.pollModel.hashCode.toString(),
              hasVoted: (widget.pollModel.choice == null) ? false : true,
              pollEnded: (widget.pollModel.endsOn == null ||
                      DateTime.now().isBefore(widget.pollModel.endsOn!))
                  ? false
                  : true,
              votedCheckmark: Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              pollOptionsBorderRadius: BorderRadius.circular(12),
              pollOptionsFillColor: pollBackgroundColor,
              pollOptionsHeight: 60,
              userVotedOptionId: widget.pollModel.choice,
              votedProgressColor:
                  Theme.of(context).colorScheme.primaryContainer,
              votedPollOptionsRadius: const Radius.circular(12),
              votedBackgroundColor: pollBackgroundColor,
              // metaWidget: ,
              leadingVotedProgessColor:
                  Theme.of(context).colorScheme.tertiaryContainer,
              pollOptionsBorder: Border.all(style: BorderStyle.none),
              votesTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              votedPercentageTextStyle: pollTextStyle,
              pollTitle: const SizedBox.shrink(),
              pollOptions: widget.pollModel.options.map(
                (optionModel) {
                  return PollOption(
                    id: optionModel.id,
                    title: Text(
                      optionModel.option,
                      style: pollTextStyle,
                    ),
                    votes: optionModel.reaction.length,
                  );
                },
              ).toList(),
              onVoted: (PollOption pollOption, int newTotalVotes) async {
                bool success =
                    await Provider.of<PollPostProvider>(context, listen: false)
                        .pollTheOption(optionID: pollOption.id!);
                if (!success) {
                  showSnackBar(
                    context: context,
                    errorSnackBar: true,
                  );
                }
                return success;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PollModel {
  final List<PollOptionModel> options;
  int? choice;
  final DateTime? endsOn;

  PollModel({required this.options, this.choice, this.endsOn});
}
