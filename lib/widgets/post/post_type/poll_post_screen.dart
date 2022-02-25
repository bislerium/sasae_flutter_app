import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_post.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/poked_ngo_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/poll_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_author_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_description_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_related_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_tail_card.dart';

import '../../misc/custom_widgets.dart';

class PollPostScreen extends StatefulWidget {
  final String hyperlink;

  const PollPostScreen({
    Key? key,
    required this.hyperlink,
  }) : super(key: key);

  @override
  _PollPostScreenState createState() => _PollPostScreenState();
}

class _PollPostScreenState extends State<PollPostScreen> {
  _PollPostScreenState() : isLoaded = false;

  PollPost? _pollPost;
  bool isLoaded;

  @override
  void initState() {
    super.initState();
    _getPollPost();
  }

  PollPost _randomPollPost() {
    Random rand = Random();
    var pollOptions = List.generate(
      faker.randomGenerator.integer(10, min: 2),
      (index) => PollOption(
        option: faker.food.dish(),
        numReaction: faker.randomGenerator.integer(500),
      ),
    );
    String? choice = faker.randomGenerator.boolean()
        ? null
        : (faker.randomGenerator
            .fromPattern(pollOptions.map((e) => e.option).toList()));
    return PollPost(
      content: faker.lorem.sentences(rand.nextInt(20 - 3) + 3).join(' '),
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
      postType: 'Poll Post',
      relatedTo: List.generate(
        rand.nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      author: faker.person.firstName(),
      endsOn: faker.randomGenerator.boolean()
          ? faker.date.dateTime(
              minYear: DateTime.now().year, maxYear: DateTime.now().year + 1)
          : null,
      polls: pollOptions,
      choice: choice,
    );
  }

  Future<void> _getPollPost({bool isDemo = true}) async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      if (isDemo) _pollPost = _randomPollPost();
      if (!isLoaded) isLoaded = true;
    });
  }

  Future<void> _refresh() async {
    await _getPollPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCustomAppBar(context: context, title: 'View Poll Post'),
      body: isLoaded
          ? RefreshIndicator(
              onRefresh: _refresh,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: ListView(
                  children: [
                    PostRelatedCard(list: _pollPost!.relatedTo),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_pollPost!.pokedNGO.isNotEmpty) ...[
                      PokedNGOCard(list: _pollPost!.pokedNGO),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                    PostContentCard(
                      content: _pollPost!.content,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PollCard(
                      key: ValueKey(_pollPost!.id),
                      list: _pollPost!.polls,
                      choice: _pollPost!.choice,
                      endsOn: _pollPost!.endsOn,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_pollPost!.isAnonymous) ...[
                      PostAuthorCard(
                        author: _pollPost!.author,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                    PostTailCard(
                      postID: _pollPost!.id,
                      createdOn: _pollPost!.createdOn,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          : const LinearProgressIndicator(),
    );
  }
}
