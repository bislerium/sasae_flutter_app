import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';

class PostTypeRow extends StatelessWidget {
  const PostTypeRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color activeColor = Theme.of(context).colorScheme.primary;
    Color inActiveColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return Consumer<PostCreateProvider>(
      builder: (context, postCreateP, child) => Row(
        children: [
          IconButton(
            onPressed: () =>
                postCreateP.setCreatePostType = PostType.normalPost,
            icon: const Icon(
              Icons.file_present_rounded,
            ),
            color: postCreateP.getCreatePostType == PostType.normalPost
                ? activeColor
                : inActiveColor,
            iconSize: 30,
            tooltip: 'Normal Post',
          ),
          IconButton(
            onPressed: () => postCreateP.setCreatePostType = PostType.pollPost,
            icon: const Icon(
              Icons.poll_rounded,
            ),
            color: postCreateP.getCreatePostType == PostType.pollPost
                ? activeColor
                : inActiveColor,
            iconSize: 30,
            tooltip: 'Poll Post',
          ),
          IconButton(
            onPressed: () =>
                postCreateP.setCreatePostType = PostType.requestPost,
            icon: const Icon(
              Icons.help_center,
            ),
            color: postCreateP.getCreatePostType == PostType.requestPost
                ? activeColor
                : inActiveColor,
            iconSize: 30,
            tooltip: 'Request Post',
          ),
        ],
      ),
    );
  }
}
