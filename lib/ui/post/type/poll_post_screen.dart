import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/post/type/extension/post_poll_card.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_author_card.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_description_card.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_related_card.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_tail_card.dart';
import 'package:sasae_flutter_app/ui/post/type/super/post_poked_ngo_card.dart';
import 'package:sasae_flutter_app/ui/misc/annotated_scaffold.dart';
import 'package:sasae_flutter_app/ui/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/ui/misc/custom_loading.dart';
import 'package:sasae_flutter_app/ui/misc/fetch_error.dart';

class PollPostScreen extends StatefulWidget {
  static const routeName = '/post/poll/';
  final int postID;

  const PollPostScreen({
    Key? key,
    required this.postID,
  }) : super(key: key);

  @override
  State<PollPostScreen> createState() => _PollPostScreenState();
}

class _PollPostScreenState extends State<PollPostScreen> {
  late PollPostProvider _provider;
  late final Future<void> _fetchPollPostFUTURE;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<PollPostProvider>(context, listen: false);
    _fetchPollPostFUTURE = _fetchPollPost();
  }

  @override
  void dispose() {
    _provider.nullifyPollPost();
    super.dispose();
  }

  Future<void> _fetchPollPost() async {
    await _provider.initFetchPollPost(postID: widget.postID);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedScaffold(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'View Poll Post',
        ),
        body: FutureBuilder(
          future: _fetchPollPostFUTURE,
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const ScreenLoading()
              : Consumer<PollPostProvider>(
                  builder: (context, postP, child) => RefreshIndicator(
                    onRefresh: () async => await refreshCallBack(
                      context: context,
                      func: () async =>
                          await postP.refreshPollPost(postID: widget.postID),
                    ),
                    child: postP.getPollPostData == null
                        ? const ErrorView()
                        : ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
                            children: [
                              PostRelatedCard(
                                  list: postP.getPollPostData!.relatedTo),
                              if (postP.getPollPostData!.pokedNGO.isNotEmpty)
                                PokedNGOCard(
                                    list: postP.getPollPostData!.pokedNGO),
                              PollCard(
                                key: ObjectKey(postP.getPollPostData),
                                isConsideredVoted:
                                    postP.getPollPostData!.isPersonalPost,
                                pollModel: PollModel(
                                  options: postP.getPollPostData!.polls,
                                  choice: postP.getPollPostData!.choice,
                                  endsOn: postP.getPollPostData!.endsOn,
                                ),
                              ),
                              PostContentCard(
                                content: postP.getPollPostData!.postContent,
                              ),
                              if (!(postP.getPollPostData!.isPersonalPost ||
                                  postP.getPollPostData!.isAnonymous))
                                PostAuthorCard(
                                  author: postP.getPollPostData!.author!,
                                ),
                              PostTailCard(
                                postID: postP.getPollPostData!.id,
                                createdOn: postP.getPollPostData!.createdOn,
                                modifiedOn: postP.getPollPostData!.modifiedOn,
                                isReportButtonVisible:
                                    !postP.getPollPostData!.isPersonalPost,
                              ),
                            ],
                          ),
                  ),
                ),
        ),
      ),
    );
  }
}
