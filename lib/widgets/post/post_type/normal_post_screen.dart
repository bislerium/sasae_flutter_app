import 'package:flutter/material.dart';
import '../../../models/post/normal_post.dart';
import '../../misc/custom_widgets.dart';
import 'voting_bar.dart';

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
        scrollController = ScrollController();

  NormalPost? _postNormal;
  bool isLoaded;
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

  Future<void> _getNormalPost() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _postNormal = NormalPost();
      isLoaded = true;
    });
  }

  Future<void> _refresh() async {
    await _getNormalPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCustomAppBar(context: context, title: 'View Normal Post'),
      body: isLoaded
          ? RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                controller: scrollController,
                children: [
                  ...List.generate(
                      40,
                      (index) => Container(
                          margin: EdgeInsets.all(10),
                          height: 40,
                          color: Colors.red.withBlue(2 * index)
                            ..withGreen(5 * index)
                            ..withRed(2 * index)))
                ],
              ),
            )
          : const LinearProgressIndicator(),
      bottomNavigationBar: isLoaded
          ? VotingBar(
              postID: 1,
              upvoteCount: 999,
              downvoteCount: 999,
              scrollController: scrollController,
            )
          : null,
    );
  }
}
