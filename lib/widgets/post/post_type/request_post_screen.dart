import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/models/post/request_post.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/poked_ngo_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_author_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_description_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_related_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_tail_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/request_fab.dart';

import 'post_dependent_widgets/request_card.dart';

class RequestPostScreen extends StatefulWidget {
  final String hyperlink;

  const RequestPostScreen({Key? key, required this.hyperlink})
      : super(key: key);

  @override
  _RequestPostScreenState createState() => _RequestPostScreenState();
}

class _RequestPostScreenState extends State<RequestPostScreen> {
  _RequestPostScreenState()
      : isLoaded = false,
        scrollController = ScrollController();

  RequestPost? _requestPost;
  bool isLoaded;
  ScrollController scrollController;
  double? animationDuration;

  @override
  void initState() {
    super.initState();
    _getRequestPost();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void updateParticipation() => setState(() {
        _requestPost!.numParticipation++;
        _requestPost!.isParticipated = true;
        animationDuration = 0;
      });

  RequestPost _randomRequestPost() {
    Random rand = Random();
    int min = faker.randomGenerator.integer(1500);
    int target = faker.randomGenerator.integer(2000, min: min);
    int? max = faker.randomGenerator.boolean()
        ? faker.randomGenerator.integer(3000, min: target)
        : null;
    int numReaction = faker.randomGenerator.integer(max ?? (target * 2));
    return RequestPost(
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
      postType: 'Request Post',
      relatedTo: List.generate(
        rand.nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      author: faker.person.firstName(),
      endsOn: faker.date.dateTime(
          minYear: DateTime.now().year - 1, maxYear: DateTime.now().year + 1),
      isParticipated: numReaction > 0 ? faker.randomGenerator.boolean() : false,
      min: min,
      target: target,
      max: max,
      numParticipation: numReaction,
      requestType: faker.randomGenerator.fromPattern(['Join', 'Petition']),
    );
  }

  Future<void> _getRequestPost({bool isDemo = true}) async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      if (isDemo) _requestPost = _randomRequestPost();
      if (!isLoaded) isLoaded = true;
    });
  }

  Future<void> _refresh() async {
    await _getRequestPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'View Request Post',
      ),
      body: isLoaded
          ? RefreshIndicator(
              onRefresh: _refresh,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: ListView(
                  controller: scrollController,
                  children: [
                    PostRelatedCard(list: _requestPost!.relatedTo),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_requestPost!.pokedNGO.isNotEmpty) ...[
                      PokedNGOCard(list: _requestPost!.pokedNGO),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                    RequestCard(
                      key: ValueKey(_requestPost!.hashCode),
                      min: _requestPost!.min,
                      target: _requestPost!.target,
                      max: _requestPost!.max,
                      requestType: _requestPost!.requestType,
                      numReaction: _requestPost!.numParticipation,
                      endsOn: _requestPost!.endsOn,
                      animationDuration: animationDuration,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PostContentCard(
                      content: _requestPost!.description,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_requestPost!.isAnonymous) ...[
                      PostAuthorCard(
                        author: _requestPost!.author,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                    PostTailCard(
                      postID: _requestPost!.id,
                      createdOn: _requestPost!.createdOn,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          : const LinearProgressIndicator(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isLoaded
          ? RequestFAB(
              key: ValueKey(_requestPost!.id),
              postID: _requestPost!.id,
              isParticipated: _requestPost!.isParticipated,
              requestType: _requestPost!.requestType,
              endsOn: _requestPost!.endsOn,
              scrollController: scrollController,
              handler: updateParticipation,
            )
          : null,
    );
  }
}
