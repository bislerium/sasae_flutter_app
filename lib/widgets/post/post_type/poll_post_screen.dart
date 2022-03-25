import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/poked_ngo_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/poll_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_author_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_description_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_related_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_tail_card.dart';

class PollPostScreen extends StatefulWidget {
  static const routeName = '/post/poll';
  final int postID;

  const PollPostScreen({
    Key? key,
    required this.postID,
  }) : super(key: key);

  @override
  _PollPostScreenState createState() => _PollPostScreenState();
}

class _PollPostScreenState extends State<PollPostScreen> {
  late PollPostProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<PollPostProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _provider.nullifyPollPost();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'View Poll Post',
      ),
      body: FutureBuilder(
        future: _provider.fetchPollPost(postID: widget.postID),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  LinearProgressIndicator(),
                ],
              )
            : Consumer<PollPostProvider>(
                builder: (context, postP, child) => RefreshIndicator(
                  onRefresh: () => postP.refreshPollPost(postID: widget.postID),
                  child: postP.pollPostData == null
                      ? const FetchError()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: ListView(
                            children: [
                              PostRelatedCard(
                                  list: postP.pollPostData!.relatedTo),
                              const SizedBox(
                                height: 10,
                              ),
                              if (postP.pollPostData!.pokedNGO.isNotEmpty) ...[
                                PokedNGOCard(
                                    list: postP.pollPostData!.pokedNGO),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                              PollCard(
                                key: ValueKey(
                                    'pollPolls${postP.pollPostData!.id}'),
                                list: postP.pollPostData!.polls,
                                choice: postP.pollPostData!.choice,
                                endsOn: postP.pollPostData!.endsOn,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              PostContentCard(
                                content: postP.pollPostData!.description,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (postP.pollPostData!.isAnonymous) ...[
                                PostAuthorCard(
                                  author: postP.pollPostData!.author!,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                              PostTailCard(
                                postID: postP.pollPostData!.id,
                                createdOn: postP.pollPostData!.createdOn,
                              ),
                              const SizedBox(
                                height: 20,
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
