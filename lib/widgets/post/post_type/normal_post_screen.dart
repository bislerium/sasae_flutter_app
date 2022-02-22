import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/post/ngo__.dart';
import '../../../models/post/normal_post.dart';
import '../../misc/custom_widgets.dart';
import './voting_bar.dart';

class PostNormalScreen extends StatefulWidget {
  final String hyperlink;

  const PostNormalScreen({
    Key? key,
    required this.hyperlink,
  }) : super(key: key);

  @override
  _PostNormalScreenState createState() => _PostNormalScreenState();
}

class _PostNormalScreenState extends State<PostNormalScreen> {
  _PostNormalScreenState()
      : isLoaded = false,
        hidePostAuthor = true,
        scrollController = ScrollController();

  NormalPost? _normalPost;
  bool isLoaded;
  bool hidePostAuthor;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _getNormalPost();
  }

  @override
  void dispose() {
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
      content: faker.lorem.sentences(rand.nextInt(20 - 3) + 3).join(' '),
      createdOn:
          faker.date.dateTime(minYear: 2020, maxYear: DateTime.now().year),
      id: faker.randomGenerator.integer(1000),
      isAnonymous: faker.randomGenerator.boolean(),
      pokedNGO: List.generate(
          faker.randomGenerator.integer(8, min: 1),
          (index) => NGO__(
                id: faker.randomGenerator.integer(1000),
                ngoURL: faker.internet.httpsUrl(),
                orgName: faker.company.name(),
                orgPhoto: faker.image.image(random: true),
              )),
      postType: faker.randomGenerator.element([
        'Normal Post',
        'Poll Post',
        'Join Request Post',
        'Petition Request Post'
      ]),
      relatedTo: List.generate(
        Random().nextInt(8 - 1) + 1,
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

  void toggleHidePostAuthor() => setState(() {
        hidePostAuthor ? hidePostAuthor = false : hidePostAuthor = true;
      });

  Widget customCard({
    required Widget child,
    EdgeInsets childPadding = const EdgeInsets.all(15.0),
    double borderRadius = 20,
  }) =>
      Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        shadowColor: Theme.of(context).colorScheme.shadow,
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: childPadding,
          child: child,
        ),
      );

  Widget postRelatedTo() => customCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Related to:',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            getWrappedChips(
              context: context,
              list: _normalPost!.relatedTo,
              center: false,
            ),
          ],
        ),
      );

  Widget pokedNGO() => customCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Poked NGO:',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            getWrappedClickableChips(
              context: context,
              list: _normalPost!.pokedNGO,
            ),
          ],
        ),
      );

  Widget postBody() => customCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content:',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              _normalPost!.content,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      );

  Widget postImageAttachment() => customCard(
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
      );

  Widget postAuthor() => customCard(
        childPadding: EdgeInsets.zero,
        borderRadius: 30,
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(30),
          onTap: toggleHidePostAuthor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(
                  Icons.remove_red_eye,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Tooltip(
                  message:
                      'Don\'t judge, bias, or ignore the post based on the author!',
                  preferBelow: false,
                  verticalOffset: 30,
                  showDuration: const Duration(seconds: 2),
                  child: Text(
                    'Reveal the author?',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: !hidePostAuthor,
                    child: Text(
                      _normalPost!.author,
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget postTail() => customCard(
        childPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        borderRadius: 30,
        child: Row(
          children: [
            Icon(
              Icons.post_add,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                DateFormat.yMMMEd().format(_normalPost!.createdOn),
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(
                height: 60,
                width: 140,
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  showCustomDialog(
                    context: context,
                    title: 'Report',
                    content: 'Are you Sure?',
                    okFunc: () {},
                  );
                },
                icon: const Icon(Icons.report_outlined),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.error,
                  onPrimary: Theme.of(context).colorScheme.onError,
                  shape: const StadiumBorder(),
                ),
                label: const Text(
                  'Report',
                ),
              ),
            )
          ],
        ),
      );

  Widget _votingBar() => VotingBar(
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
      appBar: getCustomAppBar(context: context, title: 'View Normal Post'),
      body: isLoaded
          ? RefreshIndicator(
              onRefresh: _refresh,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: ListView(
                  controller: scrollController,
                  children: [
                    postRelatedTo(),
                    const SizedBox(
                      height: 10,
                    ),
                    pokedNGO(),
                    const SizedBox(
                      height: 10,
                    ),
                    postBody(),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_normalPost!.attachedImage != null) ...[
                      postImageAttachment(),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                    postAuthor(),
                    const SizedBox(
                      height: 10,
                    ),
                    postTail(),
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
