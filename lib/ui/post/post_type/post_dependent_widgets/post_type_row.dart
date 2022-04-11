import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';

class PostTypeRow extends StatelessWidget {
  const PostTypeRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PostCreateProvider>(
      builder: (context, postCreateP, child) => DefaultTabController(
        initialIndex: postCreateP.getCreatePostType.index,
        length: 3,
        child: TabBar(
          isScrollable: true,
          labelColor: Theme.of(context).colorScheme.onSecondaryContainer,
          unselectedLabelColor: Theme.of(context).colorScheme.secondary,
          indicator: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(30),
          ),
          enableFeedback: true,
          onTap: (index) {
            switch (index) {
              case 0:
                postCreateP.setCreatePostType = PostType.normal;
                break;
              case 1:
                postCreateP.setCreatePostType = PostType.poll;
                break;
              case 2:
                postCreateP.setCreatePostType = PostType.request;
                break;
            }
          },
          tabs: const [
            Tab(
              icon: Icon(
                Icons.add_circle_rounded,
                size: 30,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.poll_rounded,
                size: 30,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.front_hand_rounded,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
