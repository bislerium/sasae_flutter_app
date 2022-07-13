import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/post/normal_post.dart';
import 'package:sasae_flutter_app/providers/internet_connection_provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class VotingBar extends StatefulWidget {
  final int upvoteCount;
  final int downvoteCount;
  final bool isUpvoted;
  final bool isDownvoted;
  final int postID;
  final ScrollController scrollController;

  const VotingBar({
    Key? key,
    required this.postID,
    required this.upvoteCount,
    required this.downvoteCount,
    this.isUpvoted = false,
    this.isDownvoted = false,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<VotingBar> createState() => _VotingBarState();
}

class _VotingBarState extends State<VotingBar> {
  late bool isUpvoted;
  late bool isDownvoted;
  late int upvoteCount;
  late int downvoteCount;
  late bool showVotingBar;

  @override
  void initState() {
    super.initState();
    isUpvoted = widget.isUpvoted;
    isDownvoted = widget.isDownvoted;
    upvoteCount = widget.upvoteCount;
    downvoteCount = widget.downvoteCount;
    widget.scrollController.addListener(listenScroll);
    showVotingBar = true;
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(listenScroll);
    super.dispose();
  }

  void listenScroll() {
    var direction = widget.scrollController.position.userScrollDirection;
    direction == ScrollDirection.reverse ? hide() : show();
  }

  void show() {
    if (!showVotingBar) setState(() => showVotingBar = true);
  }

  void hide() {
    if (showVotingBar) setState(() => showVotingBar = false);
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
            numToK(upvoteCount),
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
            '-${numToK(downvoteCount)}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
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
        onPressed: () async {
          if (!Provider.of<InternetConnetionProvider>(context, listen: false)
              .getConnectionStatusCallBack(context)
              .call()) return;
          setState(() => upvote());
          bool success =
              await Provider.of<NormalPostProvider>(context, listen: false)
                  .toggleReaction(NormalPostReactionType.upVote);
          if (!success) {
            setState(() => upvote());
            showSnackBar(
                context: context,
                message: 'Something went wrong!',
                errorSnackBar: true);
          }
        },
        style: TextButton.styleFrom(
            backgroundColor:
                isUpvoted ? Theme.of(context).colorScheme.primary : null,
            primary:
                isUpvoted ? Theme.of(context).colorScheme.onPrimary : null),
        child: const Icon(
          Icons.arrow_upward_rounded,
          size: 36,
        ),
      );

  Widget downvoteButton() => TextButton(
        onPressed: () async {
          if (!Provider.of<InternetConnetionProvider>(context, listen: false)
              .getConnectionStatusCallBack(context)
              .call()) return;
          setState(() => downvote());
          bool success =
              await Provider.of<NormalPostProvider>(context, listen: false)
                  .toggleReaction(NormalPostReactionType.downVote);
          if (!success) {
            setState(() => downvote());
            showSnackBar(
                context: context,
                message: 'Something went wrong!',
                errorSnackBar: true);
          }
        },
        style: TextButton.styleFrom(
            backgroundColor:
                isDownvoted ? Theme.of(context).colorScheme.primary : null,
            primary:
                isDownvoted ? Theme.of(context).colorScheme.onPrimary : null),
        child: const Icon(
          Icons.arrow_downward_rounded,
          size: 36,
        ),
      );

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: showVotingBar ? 70 : 0,
      child: Container(
        decoration: BoxDecoration(
          color: ElevationOverlay.colorWithOverlay(
              colors.surface, colors.primary, 3.0),
        ),
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      upvoteCounter(),
                      SizedBox(
                        height: 60,
                        child: VerticalDivider(
                          thickness: 2,
                          width: 20,
                          indent: 20,
                          endIndent: 20,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      downvoteCounter(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  upvoteButton(),
                  downvoteButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
