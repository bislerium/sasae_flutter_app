import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';

class PostButton extends StatelessWidget {
  const PostButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postP, child) => ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          height: 60,
          width: 120,
        ),
        child: ElevatedButton.icon(
          onPressed: postP.getPostHandler,
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
