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
                              if (!(postP.getNormalPostData!.isPersonalPost ||
                                  postP.getNormalPostData!.isAnonymous))
                                PostAuthorCard(
                                  author: postP.getNormalPostData!.author!,
                                ),
                              PostTailCard(
                                postID: postP.getNormalPostData!.id,
                                createdOn: postP.getNormalPostData!.createdOn,
                                modifiedOn: postP.getNormalPostData!.modifiedOn,
                                isReportButtonVisible:
                                    !postP.getNormalPostData!.isPersonalPost,
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
                  upVoteCount: postP.getNormalPostData!.upVote.length,
                  downVoteCount: postP.getNormalPostData!.downVote.length,
                  isUpVoted: postP.getNormalPostData!.upVoted,
                  isDownVoted: postP.getNormalPostData!.downVoted,
                  scrollController: _scrollController,
                  isUpVoteDownVoteButtonVisible:
                      !postP.getNormalPostData!.isPersonalPost,
                ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class VotingBar extends StatefulWidget {
  final int upVoteCount;
  final int downVoteCount;
  final bool isUpVoted;
  final bool isDownVoted;
  final int postID;
  final bool isUpVoteDownVoteButtonVisible;
  final ScrollController scrollController;

  const VotingBar({
    Key? key,
    required this.postID,
    required this.upVoteCount,
    required this.downVoteCount,
    this.isUpVoted = false,
    this.isDownVoted = false,
    required this.scrollController,
    this.isUpVoteDownVoteButtonVisible = true,
  }) : super(key: key);

  @override
  State<VotingBar> createState() => _VotingBarState();
}

class _VotingBarState extends State<VotingBar> {
  late bool isUpVoted;
  late bool isDownVoted;
  late int upVoteCount;
  late int downVoteCount;
  late bool showVotingBar;

  @override
  void initState() {
    super.initState();
    setWidgetValues();
    widget.scrollController.addListener(listenScroll);
    showVotingBar = true;
  }

  void setWidgetValues() {
    isUpVoted = widget.isUpVoted;
    isDownVoted = widget.isDownVoted;
    upVoteCount = widget.upVoteCount;
    downVoteCount = widget.downVoteCount;
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

  void upVote() {
    if (isUpVoted) {
      isUpVoted = false;
      upVoteCount--;
    } else {
      if (isDownVoted) downVoteCount--;
      isUpVoted = true;
      isDownVoted = false;
      upVoteCount++;
    }
  }

  void downVote() {
    if (isDownVoted) {
      isDownVoted = false;
      downVoteCount--;
    } else {
      if (isUpVoted) upVoteCount--;
      isDownVoted = true;
      isUpVoted = false;
      downVoteCount++;
    }
  }

  Widget upVoteCounter() => Row(
        children: [
          Text(
            numToK(upVoteCount),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'UpVote',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          )
        ],
      );

  Widget downVoteCounter() => Row(
        children: [
          Text(
            '-${numToK(downVoteCount)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'DownVote',
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
        setState(upVote);
        break;
      case NormalPostReactionType.downVote:
        setState(downVote);
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

  Widget upVoteButton() => TextButton(
        onPressed: () => react(NormalPostReactionType.upVote),
        style: TextButton.styleFrom(
            backgroundColor:
                isUpVoted ? Theme.of(context).colorScheme.primary : null,
            foregroundColor:
                isUpVoted ? Theme.of(context).colorScheme.onPrimary : null),
        child: const Icon(
          Icons.arrow_upward_rounded,
          size: 36,
        ),
      );

  Widget downVoteButton() => TextButton(
        onPressed: () => react(NormalPostReactionType.downVote),
        style: TextButton.styleFrom(
            backgroundColor:
                isDownVoted ? Theme.of(context).colorScheme.primary : null,
            foregroundColor:
                isDownVoted ? Theme.of(context).colorScheme.onPrimary : null),
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
                      upVoteCounter(),
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
                      downVoteCounter(),
                    ],
                  ),
                ),
              ),
              if (widget.isUpVoteDownVoteButtonVisible) ...[
                const SizedBox(
                  width: 16,
                ),
                Row(
                  children: [
                    upVoteButton(),
                    downVoteButton(),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
