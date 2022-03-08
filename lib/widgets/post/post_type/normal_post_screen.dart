import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/models/post/normal_post.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/poked_ngo_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_author_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_description_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_related_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_tail_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/normal_voting_bar.dart';

class NormalPostScreen extends StatefulWidget {
  final String hyperlink;

  const NormalPostScreen({
    Key? key,
    required this.hyperlink,
  }) : super(key: key);

  @override
  _NormalPostScreenState createState() => _NormalPostScreenState();
}

class _NormalPostScreenState extends State<NormalPostScreen> {
  _NormalPostScreenState()
      : isLoaded = false,
        scrollController = ScrollController();

  NormalPost? _normalPost;
  bool isLoaded;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _getNormalPost();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  NormalPost _randomNormalPost() {
    Random rand = Random();
    bool upvoted = faker.randomGenerator.boolean();
    return NormalPost(
      attachedImage: faker.randomGenerator.boolean()
          ? faker.image.image(random: true)
          : null,
      upVote: faker.randomGenerator.integer(1500),
      downVote: faker.randomGenerator.integer(1500),
      upVoted: upvoted,
      downVoted: upvoted ? false : faker.randomGenerator.boolean(),
      description: faker.lorem.sentences(rand.nextInt(20 - 3) + 3).join(' '),
      createdOn:
          faker.date.dateTime(minYear: 2020, maxYear: DateTime.now().year),
      id: faker.randomGenerator.integer(1000),
      isAnonymous: faker.randomGenerator.boolean(),
      pokedNGO: List.generate(
          faker.randomGenerator.integer(8, min: 0),
          (index) => NGO__(
                id: faker.randomGenerator.integer(1000),
                ngoURL: faker.internet.httpsUrl(),
                orgName: faker.company.name(),
                orgPhoto: faker.image.image(random: true),
              )),
      postType: 'Normal Post',
      relatedTo: List.generate(
        rand.nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      author: faker.person.firstName(),
    );
  }

  Future<void> _getNormalPost({bool isDemo = true}) async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      if (isDemo) _normalPost = _randomNormalPost();
      if (!isLoaded) isLoaded = true;
    });
  }

  Future<void> _refresh() async {
    await _getNormalPost();
  }

  Widget postImageAttachment() => CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Image Attachment:',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(
                height: 15,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.network(
                    _normalPost!.attachedImage!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const LinearProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _votingBar() => VotingBar(
        key: ValueKey(_normalPost!.id),
        postID: _normalPost!.id,
        upvoteCount: _normalPost!.upVote,
        downvoteCount: _normalPost!.downVote,
        isUpvoted: _normalPost!.upVoted,
        isDownvoted: _normalPost!.downVoted,
        scrollController: scrollController,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'View Normal Post',
      ),
      body: isLoaded
          ? RefreshIndicator(
              onRefresh: _refresh,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: ListView(
                  controller: scrollController,
                  children: [
                    PostRelatedCard(list: _normalPost!.relatedTo),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_normalPost!.pokedNGO.isNotEmpty) ...[
                      PokedNGOCard(list: _normalPost!.pokedNGO),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                    if (_normalPost!.attachedImage != null) ...[
                      postImageAttachment(),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                    PostContentCard(
                      content: _normalPost!.description,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_normalPost!.isAnonymous) ...[
                      PostAuthorCard(
                        author: _normalPost!.author,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                    PostTailCard(
                      postID: _normalPost!.id,
                      createdOn: _normalPost!.createdOn,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          : const LinearProgressIndicator(),
      bottomNavigationBar: isLoaded ? _votingBar() : null,
    );
  }
}
