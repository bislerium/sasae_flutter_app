import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/post/post_.dart';
import 'package:sasae_flutter_app/widgets/post/post_card.dart';

class PostList extends StatefulWidget {
  final List<Post_> posts;
  final ScrollController? scrollController;
  final bool isActionable;

  const PostList(
      {Key? key,
      required this.posts,
      this.scrollController,
      this.isActionable = false})
      : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) => ListView.builder(
        controller: widget.scrollController,
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.posts.length,
        itemBuilder: ((context, index) {
          var post = widget.posts[index];
          return PostCard(
            key: ValueKey(post.id),
            post: post,
            isActionable: widget.isActionable,
          );
        }),
      );
}
