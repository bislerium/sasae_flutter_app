import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/normal_image_attachment_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_poked_ngo_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_author_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_description_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_related_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_tail_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/normal_voting_bar.dart';

class NormalPostScreen extends StatefulWidget {
  static const routeName = '/post/normal';
  final int postID;

  const NormalPostScreen({
    Key? key,
    required this.postID,
  }) : super(key: key);

  @override
  _NormalPostScreenState createState() => _NormalPostScreenState();
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
                  onRefresh: () =>
                      postP.refreshNormalPost(postID: widget.postID),
                  child: postP.normalPostData == null
                      ? const FetchError()
                      : ListView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                          children: [
                            PostRelatedCard(
                              list: postP.normalPostData!.relatedTo,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            if (postP.normalPostData!.pokedNGO.isNotEmpty) ...[
                              PokedNGOCard(
                                list: postP.normalPostData!.pokedNGO,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            if (postP.normalPostData!.attachedImage !=
                                null) ...[
                              NormalImageAttachmentCard(
                                imageURL: postP.normalPostData!.attachedImage!,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            PostContentCard(
                              content: postP.normalPostData!.postContent,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            if (!postP.normalPostData!.isAnonymous) ...[
                              PostAuthorCard(
                                author: postP.normalPostData!.author!,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            PostTailCard(
                              postID: postP.normalPostData!.id,
                              createdOn: postP.normalPostData!.createdOn,
                              modifiedOn: postP.normalPostData!.modifiedOn,
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
        builder: (context, postP, child) => postP.normalPostData == null
            ? const SizedBox.shrink()
            : VotingBar(
                key: ObjectKey(postP.normalPostData),
                postID: postP.normalPostData!.id,
                upvoteCount: postP.normalPostData!.upVote.length,
                downvoteCount: postP.normalPostData!.downVote.length,
                isUpvoted: postP.normalPostData!.upVoted,
                isDownvoted: postP.normalPostData!.downVoted,
                scrollController: _scrollController,
              ),
      ),
    );
  }
}
