import 'package:flutter/material.dart';

import '../../misc/custom_widgets.dart';

class VotingBar extends StatefulWidget {
  final int upvoteCount;
  final int downvoteCount;
  final bool isUpvoted;
  final bool isDownvoted;
  final int postID;

  const VotingBar({
    Key? key,
    required this.postID,
    required this.upvoteCount,
    required this.downvoteCount,
    this.isUpvoted = false,
    this.isDownvoted = false,
  }) : super(key: key);

  @override
  _VotingBarState createState() => _VotingBarState();
}

class _VotingBarState extends State<VotingBar> {
  late bool isUpvoted;
  late bool isDownvoted;
  late int upvoteCount;
  late int downvoteCount;

  @override
  void initState() {
    super.initState();
    isUpvoted = widget.isUpvoted;
    isDownvoted = widget.isDownvoted;
    upvoteCount = widget.upvoteCount;
    downvoteCount = widget.downvoteCount;
  }

  Future<void> react() async {}

  void upvote() {
    if (isUpvoted) {
      isUpvoted = false;
      upvoteCount--;
    } else {
      if (isDownvoted) downvoteCount--;
      isUpvoted = true;
      isDownvoted = false;
      upvoteCount++;
    }
  }

  void downvote() {
    if (isDownvoted) {
      isDownvoted = false;
      downvoteCount--;
    } else {
      if (isUpvoted) upvoteCount--;
      isDownvoted = true;
      isUpvoted = false;
      downvoteCount++;
    }
  }

  Widget upvoteCounter() => Row(
        children: [
          Text(
            countNum(upvoteCount),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Upvote',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 15,
            ),
          )
        ],
      );

  Widget downvoteCounter() => Row(
        children: [
          Text(
            countNum(downvoteCount),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Downvote',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 15,
            ),
          )
        ],
      );

  Widget upvoteButton() => TextButton(
        onPressed: () {
          setState(() {
            upvote();
          });
        },
        child: const Icon(
          Icons.arrow_upward_rounded,
          size: 30,
        ),
        style: TextButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor:
                isUpvoted ? Theme.of(context).colorScheme.primary : null,
            primary:
                isUpvoted ? Theme.of(context).colorScheme.onPrimary : null),
      );

  Widget downvoteButton() => TextButton(
        onPressed: () {
          setState(() {
            downvote();
          });
        },
        child: const Icon(
          Icons.arrow_downward_rounded,
          size: 30,
        ),
        style: TextButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor:
                isDownvoted ? Theme.of(context).colorScheme.primary : null,
            primary:
                isDownvoted ? Theme.of(context).colorScheme.onPrimary : null),
      );

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.surface,
        ),
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Row(
                children: [
                  upvoteCounter(),
                  VerticalDivider(
                    thickness: 2,
                    width: 22,
                    indent: 12,
                    endIndent: 12,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  downvoteCounter(),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  upvoteButton(),
                  downvoteButton(),
                ],
              ),
            ],
          ),
        ),
      );
}
