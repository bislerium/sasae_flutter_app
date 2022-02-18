import 'package:flutter/material.dart';
import 'post_card.dart';
import '../../models/post_.dart';

class PostTileList extends StatefulWidget {
  final List<Post_> posts;

  const PostTileList({Key? key, required this.posts}) : super(key: key);

  @override
  _PostTileListState createState() => _PostTileListState();
}

class _PostTileListState extends State<PostTileList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: widget.posts.length,
      shrinkWrap: true,
      itemBuilder: ((context, index) {
        var post = widget.posts[index];
        return PostCard(
          key: ValueKey(post.id),
          post: post,
        );
      }),
    );
  }
}
