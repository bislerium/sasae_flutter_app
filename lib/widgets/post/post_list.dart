import 'package:flutter/material.dart';
import './post_tile.dart';
import '../../models/post.dart';

class PostTileList extends StatefulWidget {
  final List<Post> posts;

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
        return PostTile(
          key: ValueKey(post.id),
          post: post,
        );
      }),
    );
  }
}
