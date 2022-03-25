import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/poked_ngo_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_author_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_description_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_related_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_tail_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/request_fab.dart';
import 'post_dependent_widgets/request_card.dart';

class RequestPostScreen extends StatefulWidget {
  static const routeName = '/post/request';
  final int postID;

  const RequestPostScreen({Key? key, required this.postID}) : super(key: key);

  @override
  _RequestPostScreenState createState() => _RequestPostScreenState();
}

class _RequestPostScreenState extends State<RequestPostScreen> {
  late RequestPostProvider _provider;
  ScrollController scrollController;

  _RequestPostScreenState() : scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<RequestPostProvider>(context, listen: false);
  }

  @override
  void dispose() {
    scrollController.dispose();
    _provider.nullifyRequestPost();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'View Request Post',
      ),
      body: FutureBuilder(
        future: _provider.fetchRequestPost(postID: widget.postID),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  LinearProgressIndicator(),
                ],
              )
            : Consumer<RequestPostProvider>(
                builder: (context, postP, child) => RefreshIndicator(
                  onRefresh: () =>
                      postP.refreshRequestPost(postID: widget.postID),
                  child: postP.requestPostData == null
                      ? const FetchError()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: ListView(
                            controller: scrollController,
                            children: [
                              PostRelatedCard(
                                  list: postP.requestPostData!.relatedTo),
                              const SizedBox(
                                height: 10,
                              ),
                              if (postP
                                  .requestPostData!.pokedNGO.isNotEmpty) ...[
                                PokedNGOCard(
                                    list: postP.requestPostData!.pokedNGO),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                              RequestCard(
                                key: ValueKey(postP.requestPostData!.hashCode),
                                min: postP.requestPostData!.min,
                                target: postP.requestPostData!.target,
                                max: postP.requestPostData!.max,
                                requestType: postP.requestPostData!.requestType,
                                numReaction:
                                    postP.requestPostData!.numParticipation,
                                endsOn: postP.requestPostData!.endsOn,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              PostContentCard(
                                content: postP.requestPostData!.description,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (postP.requestPostData!.isAnonymous) ...[
                                PostAuthorCard(
                                  author: postP.requestPostData!.author!,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                              PostTailCard(
                                postID: postP.requestPostData!.id,
                                createdOn: postP.requestPostData!.createdOn,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<RequestPostProvider>(
        builder: (context, postP, child) => postP.requestPostData == null
            ? const SizedBox.shrink()
            : RequestFAB(
                key: ValueKey(postP.requestPostData!.id),
                postID: postP.requestPostData!.id,
                isParticipated: postP.requestPostData!.isParticipated,
                requestType: postP.requestPostData!.requestType,
                endsOn: postP.requestPostData!.endsOn,
                scrollController: scrollController,
                handler: postP.participateRequest,
              ),
      ),
    );
  }
}
