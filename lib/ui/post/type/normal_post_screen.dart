import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/post/normal_post.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_poked_ngo_card.dart';
import 'package:sasae_flutter_app/ui/post/type/extension/post_normal_card.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_author_card.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_description_card.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_related_card.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_tail_card.dart';
import 'package:sasae_flutter_app/ui/misc/annotated_scaffold.dart';
import 'package:sasae_flutter_app/ui/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/ui/misc/custom_loading.dart';
import 'package:sasae_flutter_app/ui/misc/custom_widgets.dart';
import 'package:sasae_flutter_app/ui/misc/fetch_error.dart';

class NormalPostScreen extends StatefulWidget {
  static const routeName = '/post/normal/';
  final int postID;

  const NormalPostScreen({
    Key? key,
    required this.postID,
  }) : super(key: key);

  @override
  State<NormalPostScreen> createState() => _NormalPostScreenState();
}

class _NormalPostScreenState extends State<NormalPostScreen> {
  final ScrollController _scrollController;
  late NormalPostProvider _provider;
  late Future<void> _fetchNormalPostFUTURE;

  _NormalPostScreenState() : _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<NormalPostProvider>(context, listen: false);
    _fetchNormalPostFUTURE = _fetchNormalPost();
  }

  Future<void> _fetchNormalPost() async {
    await _provider.initFetchNormalPost(postID: widget.postID);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _provider.nullifyNormalPost();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    return AnnotatedScaffold(
      systemNavigationBarColor: ElevationOverlay.colorWithOverlay(
          colors.surface, colors.primary, 3.0),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'View Normal Post',
        ),
        body: FutureBuilder(
          future: _fetchNormalPostFUTURE,
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const ScreenLoading()
              : Consumer<NormalPostProvider>(
                  builder: (context, postP, child) => RefreshIndicator(
                    onRefresh: () async => await refreshCallBack(
                      context: context,
                      func: () async =>
                          await postP.refreshNormalPost(postID: widget.postID),
                    ),
                    child: postP.getNormalPostData == null
                        ? const ErrorView()
                        : ListView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
                            children: [
                              PostRelatedCard(
                                list: postP.getNormalPostData!.relatedTo,
                              ),
                              if (postP.getNormalPostData!.pokedNGO.isNotEmpty)
                                PokedNGOCard(
                                  list: postP.getNormalPostData!.pokedNGO,
                                ),
                              if (postP.getNormalPostData!.attachedImage !=
                                  null)
                                NormalImageAttachmentCard(
                                  imageURL:
                                      postP.getNormalPostData!.attachedImage!,
                                ),
                              PostContentCard(
                                content: postP.getNormalPostData!.postContent,
                              ),
                              if (!postP.getNormalPostData!.isAnonymous)
                                PostAuthorCard(
                                  author: postP.getNormalPostData!.author!,
                                ),
                              PostTailCard(
                                postID: postP.getNormalPostData!.id,
                                createdOn: postP.getNormalPostData!.createdOn,
                                modifiedOn: postP.getNormalPostData!.modifiedOn,
                              ),
                            ],
                          ),
                  ),
                ),
        ),
        bottomNavigationBar: Consumer<NormalPostProvider>(
          builder: (context, postP, child) => postP.getNormalPostData == null
              ? const SizedBox.shrink()
              : VotingBar(
                  key: ObjectKey(postP.getNormalPostData),
                  postID: postP.getNormalPostData!.id,
                  upvoteCount: postP.getNormalPostData!.upVote.length,
                  downvoteCount: postP.getNormalPostData!.downVote.length,
                  isUpvoted: postP.getNormalPostData!.upVoted,
                  isDownvoted: postP.getNormalPostData!.downVoted,
                  scrollController: _scrollController,
                ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

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
    setWidgetValues();
    widget.scrollController.addListener(listenScroll);
    showVotingBar = true;
  }

  void setWidgetValues() {
    isUpvoted = widget.isUpvoted;
    isDownvoted = widget.isDownvoted;
    upvoteCount = widget.upvoteCount;
    downvoteCount = widget.downvoteCount;
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

  void onErrorFallBack() => setState(setWidgetValues);

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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Upvote',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          )
        ],
      );

  Widget downvoteCounter() => Row(
        children: [
          Text(
            '-${numToK(downvoteCount)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Downvote',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          )
        ],
      );

  Future<void> react(NormalPostReactionType type) async {
    if (!isInternetConnected(context)) return;
    if (!isProfileVerified(context)) return;
    switch (type) {
      case NormalPostReactionType.upVote:
        setState(upvote);
        break;
      case NormalPostReactionType.downVote:
        setState(downvote);
    }
    bool success = await Provider.of<NormalPostProvider>(context, listen: false)
        .toggleReaction(type);
    if (!success) {
      onErrorFallBack();
      showSnackBar(
          context: context,
          message: 'Something went wrong!',
          errorSnackBar: true);
    }
  }

  Widget upvoteButton() => TextButton(
        onPressed: () => react(NormalPostReactionType.upVote),
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
        onPressed: () => react(NormalPostReactionType.downVote),
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
                width: 16,
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
