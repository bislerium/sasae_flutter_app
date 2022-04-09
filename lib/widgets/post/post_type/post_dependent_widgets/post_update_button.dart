import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_scroll_animated_fab.dart';

class PostUpdateButton extends StatelessWidget {
  final ScrollController scrollController;
  const PostUpdateButton({Key? key, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PostUpdateProvider>(
      builder: (context, postUpdateP, child) => CustomScrollAnimatedFAB(
        text: 'Done',
        icon: Icons.done_rounded,
        scrollController: scrollController,
        func: postUpdateP.getPostUpdateHandler,
      ),
    );
  }
}
