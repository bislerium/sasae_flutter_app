import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/providers/post_interface.dart';
import 'package:sasae_flutter_app/ui/post/module/post_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';

class PostList extends StatefulWidget {
  final IPost postInterface;
  final ScrollController? scrollController;
  final bool isActionable;

  const PostList(
      {Key? key,
      required this.postInterface,
      this.scrollController,
      this.isActionable = false})
      : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    var postData = widget.postInterface.getPosts!;
    return ListView.builder(
      key: ValueKey(widget.postInterface.getPosts.hashCode),
      controller: widget.scrollController,
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: postData.length + 1,
      itemBuilder: ((context, index) {
        if (index < postData.length) {
          var post = postData[index];
          return PostCard(
            key: ValueKey(post.id),
            post: post,
            isActionable: widget.isActionable,
          );
        } else {
          return Center(
            child:
                widget.postInterface.getHasMore ? const ButtomLoading() : null,
          );
        }
      }),
    );
  }
}
