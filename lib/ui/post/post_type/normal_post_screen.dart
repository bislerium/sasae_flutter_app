import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/normal_image_attachment_card.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/post_poked_ngo_card.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/post_author_card.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/post_description_card.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/post_related_card.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/post_tail_card.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/normal_voting_bar.dart';

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
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'View Normal Post',
      ),
      body: FutureBuilder(
        future: _fetchNormalPostFUTURE,
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const CustomLoading()
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
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                          children: [
                            PostRelatedCard(
                              list: postP.getNormalPostData!.relatedTo,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            if (postP
                                .getNormalPostData!.pokedNGO.isNotEmpty) ...[
                              PokedNGOCard(
                                list: postP.getNormalPostData!.pokedNGO,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            if (postP.getNormalPostData!.attachedImage !=
                                null) ...[
                              NormalImageAttachmentCard(
                                imageURL:
                                    postP.getNormalPostData!.attachedImage!,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            PostContentCard(
                              content: postP.getNormalPostData!.postContent,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            if (!postP.getNormalPostData!.isAnonymous) ...[
                              PostAuthorCard(
                                author: postP.getNormalPostData!.author!,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            PostTailCard(
                              postID: postP.getNormalPostData!.id,
                              createdOn: postP.getNormalPostData!.createdOn,
                              modifiedOn: postP.getNormalPostData!.modifiedOn,
                            ),
                            const SizedBox(
                              height: 15,
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
    );
  }
}
