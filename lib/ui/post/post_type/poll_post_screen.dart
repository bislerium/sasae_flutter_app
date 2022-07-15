import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/widgets/misc/annotated_scaffold.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/post_poked_ngo_card.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/poll_card.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/post_author_card.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/post_description_card.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/post_related_card.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/post_tail_card.dart';

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
              ? const CustomLoading()
              : Consumer<PollPostProvider>(
                  builder: (context, postP, child) => RefreshIndicator(
                    onRefresh: () async => await refreshCallBack(
                      context: context,
                      func: () async =>
                          await postP.refreshPollPost(postID: widget.postID),
                    ),
                    child: postP.pollPostData == null
                        ? const ErrorView()
                        : ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                            children: [
                              PostRelatedCard(
                                  list: postP.pollPostData!.relatedTo),
                              const SizedBox(
                                height: 15,
                              ),
                              if (postP.pollPostData!.pokedNGO.isNotEmpty) ...[
                                PokedNGOCard(
                                    list: postP.pollPostData!.pokedNGO),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                              PollCard(
                                key: ObjectKey(postP.pollPostData),
                                pollModel: PollModel(
                                  options: postP.pollPostData!.polls,
                                  choice: postP.pollPostData!.choice,
                                  endsOn: postP.pollPostData!.endsOn,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              PostContentCard(
                                content: postP.pollPostData!.postContent,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              if (!postP.pollPostData!.isAnonymous) ...[
                                PostAuthorCard(
                                  author: postP.pollPostData!.author!,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                              PostTailCard(
                                postID: postP.pollPostData!.id,
                                createdOn: postP.pollPostData!.createdOn,
                                modifiedOn: postP.pollPostData!.modifiedOn,
                              ),
                              const SizedBox(
                                height: 15,
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
