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
import 'package:sasae_flutter_app/widgets/misc/annotated_scaffold.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_scroll_animated_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

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
                    child: postP.requestPostData == null
                        ? const ErrorView()
                        : ListView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                            children: [
                              PostRelatedCard(
                                  list: postP.requestPostData!.relatedTo),
                              const SizedBox(
                                height: 15,
                              ),
                              if (postP
                                  .requestPostData!.pokedNGO.isNotEmpty) ...[
                                PokedNGOCard(
                                    list: postP.requestPostData!.pokedNGO),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                              RequestCard(
                                key: ValueKey(postP.requestPostData!.hashCode),
                                min: postP.requestPostData!.min,
                                target: postP.requestPostData!.target,
                                max: postP.requestPostData!.max,
                                requestType: postP.requestPostData!.requestType,
                                numReaction:
                                    postP.requestPostData!.reaction.length,
                                endsOn: postP.requestPostData!.endsOn,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              PostContentCard(
                                content: postP.requestPostData!.postContent,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              if (!postP.requestPostData!.isAnonymous) ...[
                                PostAuthorCard(
                                  author: postP.requestPostData!.author!,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                              PostTailCard(
                                postID: postP.requestPostData!.id,
                                createdOn: postP.requestPostData!.createdOn,
                                modifiedOn: postP.requestPostData!.modifiedOn,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                  ),
                ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Consumer<RequestPostProvider>(
          builder: (context, postP, child) => postP.requestPostData == null
              ? const SizedBox.shrink()
              : RequestFAB(
                  postID: postP.requestPostData!.id,
                  isRequestConsidered: postP.requestPostData!.isParticipated,
                  requestType: postP.requestPostData!.requestType,
                  endsOn: postP.requestPostData!.endsOn,
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
            ? ButtomLoading(
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
