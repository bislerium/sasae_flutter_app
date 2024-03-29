import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_poked_ngo_card.dart';
import 'package:sasae_flutter_app/ui/post/type/extension/post_request_card.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_author_card.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_description_card.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_related_card.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_tail_card.dart';
import 'package:sasae_flutter_app/ui/misc/annotated_scaffold.dart';
import 'package:sasae_flutter_app/ui/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/ui/misc/custom_loading.dart';
import 'package:sasae_flutter_app/ui/misc/fetch_error.dart';
import 'package:sasae_flutter_app/ui/misc/custom_scroll_animated_fab.dart';
import 'package:sasae_flutter_app/ui/misc/custom_widgets.dart';

class RequestPostScreen extends StatefulWidget {
  static const routeName = '/post/request/';
  final int postID;

  const RequestPostScreen({Key? key, required this.postID}) : super(key: key);

  @override
  State<RequestPostScreen> createState() => _RequestPostScreenState();
}

class _RequestPostScreenState extends State<RequestPostScreen> {
  late final RequestPostProvider _provider;
  final ScrollController _scrollController;
  late final Future<void> _fetchRequestPostFUTURE;

  _RequestPostScreenState() : _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<RequestPostProvider>(context, listen: false);
    _fetchRequestPostFUTURE = _fetchRequestPost();
  }

  Future<void> _fetchRequestPost() async {
    await _provider.intiFetchRequestPost(postID: widget.postID);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _provider.nullifyRequestPost();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedScaffold(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'View Request Post',
        ),
        body: FutureBuilder(
          future: _fetchRequestPostFUTURE,
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const ScreenLoading()
              : Consumer<RequestPostProvider>(
                  builder: (context, postP, child) => RefreshIndicator(
                    onRefresh: () async => await refreshCallBack(
                      context: context,
                      func: () async =>
                          await postP.refreshRequestPost(postID: widget.postID),
                    ),
                    child: postP.getRequestPostData == null
                        ? const ErrorView()
                        : ListView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
                            children: [
                              PostRelatedCard(
                                  list: postP.getRequestPostData!.relatedTo),
                              if (postP.getRequestPostData!.pokedNGO.isNotEmpty)
                                PokedNGOCard(
                                    list: postP.getRequestPostData!.pokedNGO),
                              RequestCard(
                                key: ValueKey(
                                    postP.getRequestPostData!.hashCode),
                                min: postP.getRequestPostData!.min,
                                target: postP.getRequestPostData!.target,
                                max: postP.getRequestPostData!.max,
                                requestType:
                                    postP.getRequestPostData!.requestType,
                                numReaction:
                                    postP.getRequestPostData!.reaction.length,
                                endsOn: postP.getRequestPostData!.endsOn,
                              ),
                              PostContentCard(
                                content: postP.getRequestPostData!.postContent,
                              ),
                              if (!(postP.getRequestPostData!.isPersonalPost ||
                                  postP.getRequestPostData!.isAnonymous))
                                PostAuthorCard(
                                  author: postP.getRequestPostData!.author!,
                                ),
                              PostTailCard(
                                postID: postP.getRequestPostData!.id,
                                createdOn: postP.getRequestPostData!.createdOn,
                                modifiedOn:
                                    postP.getRequestPostData!.modifiedOn,
                                isReportButtonVisible:
                                    !postP.getRequestPostData!.isPersonalPost,
                              ),
                            ],
                          ),
                  ),
                ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Consumer<RequestPostProvider>(
          builder: (context, postP, child) => postP.getRequestPostData == null
              ? const SizedBox.shrink()
              : postP.getRequestPostData!.isPersonalPost
                  ? const SizedBox.shrink()
                  : RequestFAB(
                      postID: postP.getRequestPostData!.id,
                      isRequestConsidered:
                          postP.getRequestPostData!.isParticipated,
                      requestType: postP.getRequestPostData!.requestType,
                      endsOn: postP.getRequestPostData!.endsOn,
                      scrollController: _scrollController,
                    ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class RequestFAB extends StatefulWidget {
  final int postID;
  final ScrollController scrollController;
  final String requestType;
  final DateTime endsOn;
  final bool isRequestConsidered;

  const RequestFAB({
    Key? key,
    required this.postID,
    required this.scrollController,
    required this.isRequestConsidered,
    required this.requestType,
    required this.endsOn,
  }) : super(key: key);

  @override
  State<RequestFAB> createState() => _RequestFABState();
}

class _RequestFABState extends State<RequestFAB> {
  bool _isLoading;
  _RequestFABState() : _isLoading = false;

  Future<void> requestCallBack() async {
    if (_isLoading) return;
    if (widget.isRequestConsidered) {
      showSnackBar(
          context: context,
          message: widget.requestType == 'Petition'
              ? 'Already signed'
              : 'Already joined',
          errorSnackBar: true);
      return;
    }
    if (DateTime.now().isAfter(widget.endsOn)) {
      showSnackBar(
        context: context,
        message: '${widget.requestType} request expired',
        errorSnackBar: true,
      );
      return;
    }
    if (!isInternetConnected(context)) return;
    if (!isProfileVerified(context)) return;
    showCustomDialog(
      context: context,
      content: 'Once participated, You cannot undo!',
      okFunc: () async {
        if (!isInternetConnected(context)) return;
        if (!isProfileVerified(context)) return;
        Navigator.of(context).pop();
        setState(() => _isLoading = true);
        var success =
            await Provider.of<RequestPostProvider>(context, listen: false)
                .considerRequest();
        setState(() => _isLoading = false);
        if (!success) {
          showSnackBar(
            context: context,
            errorSnackBar: true,
          );
        }
      },
      title: 'Confirm ${widget.requestType}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollAnimatedFAB(
      scrollController: widget.scrollController,
      child: FloatingActionButton.large(
        onPressed: requestCallBack,
        elevation: 3,
        child: _isLoading
            ? ButtonLoading(
                color: Theme.of(context).colorScheme.onPrimaryContainer)
            : widget.requestType == 'Petition'
                ? widget.isRequestConsidered
                    ? const Icon(Icons.draw)
                    : const Icon(Icons.draw_outlined)
                : widget.isRequestConsidered
                    ? const Icon(Icons.handshake_rounded)
                    : const Icon(Icons.handshake_outlined),
      ),
    );
  }
}
