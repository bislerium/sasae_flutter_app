import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/models/post/normal_post.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_post.dart';
import 'package:sasae_flutter_app/models/post/post_.dart';
import 'package:sasae_flutter_app/models/post/request_post.dart';

class PostProvider with ChangeNotifier {
  List<Post_>? _posts;

  List<Post_>? get postData => _posts;

  void _randPosts() {
    var random = Random();
    int length = random.nextInt(100 - 20) + 20;
    _posts = List.generate(
      length,
      (index) {
        return Post_(
          id: index,
          postURL: faker.internet.httpsUrl(),
          relatedTo: List.generate(
            random.nextInt(8 - 1) + 1,
            (index) => faker.lorem.word(),
          ),
          postContent:
              faker.lorem.sentences(random.nextInt(15 - 2) + 2).join(' '),
          postedOn: faker.date.dateTime(minYear: 2018, maxYear: 2022),
          postType: faker.randomGenerator.fromPattern([
            'Normal Post',
            'Poll Post',
            'Join Request Post',
            'Petition Request Post'
          ]),
          isPostedAnonymously: faker.randomGenerator.boolean(),
          isPokedToNGO: faker.randomGenerator.boolean(),
        );
      },
    );
  }

  Future<void> fetchPosts({bool isDemo = true}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (isDemo) _randPosts();
    notifyListeners();
  }

  Future<void> refreshPosts() async {
    await fetchPosts();
  }

  Future<bool> report({required int postID}) async {
    return true;
  }
}

//------------------------------Normal Post --------------------------------//

class NormalPostProvider with ChangeNotifier {
  NormalPost? _normalPost;

  NormalPost? get normalPostData => _normalPost;

  void _randNormalPost() {
    Random rand = Random();
    bool upvoted = faker.randomGenerator.boolean();
    _normalPost = NormalPost(
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

  Future<void> fetchNormalPost(
      {required int postID, bool isDemo = true}) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (isDemo) _randNormalPost();
    notifyListeners();
  }

  Future<void> refreshNormalPost({required int postID}) async {
    await fetchNormalPost(postID: postID);
  }

  void nullifyNormalPost() => _normalPost = null;
}

//--------------------------------Poll Post ----------------------------------//

class PollPostProvider with ChangeNotifier {
  PollPost? _pollPost;

  PollPost? get pollPostData => _pollPost;

  void _randPollPost() {
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
    _pollPost = PollPost(
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
      postType: 'Poll Post',
      relatedTo: List.generate(
        rand.nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      author: faker.person.firstName(),
      endsOn: faker.randomGenerator.boolean()
          ? faker.date.dateTime(
              minYear: DateTime.now().year - 1,
              maxYear: DateTime.now().year + 1)
          : null,
      polls: pollOptions,
      choice: choice,
    );
  }

  Future<void> fetchPollPost({required int postID, bool isDemo = true}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (isDemo) _randPollPost();
    notifyListeners();
  }

  Future<void> refreshPollPost({required int postID}) async {
    await fetchPollPost(postID: postID);
  }

  void nullifyPollPost() => _pollPost = null;
}

//-------------------------------Request Post --------------------------------//

class RequestPostProvider with ChangeNotifier {
  RequestPost? _requestPost;

  RequestPost? get requestPostData => _requestPost;

  void _randRequestPost() {
    Random rand = Random();
    int min = faker.randomGenerator.integer(1500);
    int target = faker.randomGenerator.integer(2000, min: min);
    int? max = faker.randomGenerator.boolean()
        ? faker.randomGenerator.integer(3000, min: target)
        : null;
    int numReaction = faker.randomGenerator.integer(max ?? (target * 2));
    _requestPost = RequestPost(
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

  Future<void> fetchRequestPost(
      {required int postID, bool isDemo = true}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (isDemo) _randRequestPost();
    notifyListeners();
  }

  Future<void> refreshRequestPost({required int postID}) async {
    await fetchRequestPost(postID: postID);
  }

  //Sign for petition and join for Joinform
  Future<bool> participateRequest() async {
    _requestPost!.numParticipation++;
    _requestPost!.isParticipated = true;
    notifyListeners();
    return true;
  }

  void nullifyRequestPost() => _requestPost = null;
}
