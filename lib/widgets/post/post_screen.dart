import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import '../../models/post_.dart';
import './post_list.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with AutomaticKeepAliveClientMixin {
  List<Post_> posts = [];
  List<String> postType = [
    'Normal Post',
    'Poll Post',
    'Join Request Post',
    'Petition Request Post'
  ];

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
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
          postType: postType[random.nextInt(postType.length)],
          isPostedAnonymously: faker.randomGenerator.boolean(),
          isPokedToNGO: faker.randomGenerator.boolean(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: PostTileList(
          posts: posts,
        ),
      ),
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
