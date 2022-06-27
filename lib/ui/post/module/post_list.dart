import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/post/post_.dart';
import 'package:sasae_flutter_app/ui/post/module/post_card.dart';

class PostList extends StatefulWidget {
  final List<Post_Model> posts;
  final ScrollController? scrollController;
  final bool isActionable;

  const PostList(
      {Key? key,
      required this.posts,
      this.scrollController,
      this.isActionable = false})
      : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) => ListView.builder(
        key: ValueKey(widget.posts.hashCode),
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
