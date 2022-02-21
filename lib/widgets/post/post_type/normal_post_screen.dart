import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../models/post/normal_post.dart';
import '../../misc/custom_widgets.dart';
import 'voting_bar.dart';

class PostNormalScreen extends StatefulWidget {
  final String hyperlink;

  const PostNormalScreen({Key? key, required this.hyperlink}) : super(key: key);

  @override
  _PostNormalScreenState createState() => _PostNormalScreenState();
}

class _PostNormalScreenState extends State<PostNormalScreen> {
  _PostNormalScreenState()
      : isLoaded = false,
        showReactionBar = true;

  NormalPost? _postNormal;
  bool isLoaded;
  bool showReactionBar;

  @override
  void initState() {
    super.initState();
    _getNormalPost();
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
          ? NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                setState(() {
                  notification.direction == ScrollDirection.reverse
                      ? showReactionBar = false
                      : showReactionBar = true;
                });
                return true;
              },
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...List.generate(
                                40,
                                (index) => Container(
                                    margin: EdgeInsets.all(10),
                                    height: 40,
                                    color: Colors.red))
                          ],
                        ),
                      ),
                    ),
                    if (showReactionBar)
                      const Positioned(
                        child: VotingBar(
                          postID: 1,
                          upvoteCount: 999,
                          downvoteCount: 999,
                          isDownvoted: true,
                        ),
                      ),
                  ],
                ),
              ),
            )
          : const LinearProgressIndicator(),
    );
  }
}
