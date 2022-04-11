import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';

class PostCreateButton extends StatelessWidget {
  const PostCreateButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PostCreateProvider>(
      builder: (context, postCreateP, child) => ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          height: 60,
          width: 120,
        ),
        child: ElevatedButton.icon(
          onPressed: postCreateP.getPostCreateHandler,
          icon: const Icon(
            Icons.post_add_rounded,
          ),
          label: const Text(
            'Post',
          ),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
          ),
        ),
      ),
    );
  }
}
