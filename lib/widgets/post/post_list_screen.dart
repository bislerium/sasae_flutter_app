import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import '../../models/post.dart';
import './post_list.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  List<Post> posts = [];
  List<String> postType = [
    'Post Normal',
    'Post Poll',
    'Post Request Join',
    'Post Request Petition'
  ];

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  Future<void> _refresh() async {
    // await Future.delayed(Duration(seconds: 2));
    setState(() {
      _getPosts();
    });
  }

  void _getPosts() {
    var random = Random();
    int length = random.nextInt(100 - 20) + 20;

    posts = List.generate(
      length,
      (index) {
        return Post(
          id: index,
          postURL: faker.internet.httpsUrl(),
          relatedTo: List.generate(
            random.nextInt(8 - 1) + 1,
            (index) => faker.lorem.word(),
          ),
          postContent:
              faker.lorem.sentences(random.nextInt(15 - 2) + 2).join(' '),
          postedOn: faker.date.dateTime(minYear: 2018, maxYear: 2022),
          postType: postType[random.nextInt(postType.length)],
          isPostedAnonymously: faker.randomGenerator.boolean(),
          isPokedToNGO: faker.randomGenerator.boolean(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: PostTileList(
          posts: posts,
        ),
      ),
    );
  }
}
