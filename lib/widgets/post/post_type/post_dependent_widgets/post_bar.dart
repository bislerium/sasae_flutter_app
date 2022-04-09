import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_create_button.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_type_row.dart';

class PostBar extends StatefulWidget {
  const PostBar({Key? key}) : super(key: key);

  @override
  State<PostBar> createState() => _PostBarState();
}

class _PostBarState extends State<PostBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: const [
            PostTypeRow(),
            Spacer(),
            PostCreateButton(),
          ],
        ),
      ),
    );
  }
}
