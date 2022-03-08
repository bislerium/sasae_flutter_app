import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/post/post_.dart';

class PostProvider with ChangeNotifier {
  List<Post_>? _posts;

  PostProvider() : _posts = [];

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
  }

  Future<void> refreshPosts() async {
    await fetchPosts();
    notifyListeners();
  }
}
