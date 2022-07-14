import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';

class PostCreateButton extends StatefulWidget {
  const PostCreateButton({Key? key}) : super(key: key);

  @override
  State<PostCreateButton> createState() => _PostCreateButtonState();
}

class _PostCreateButtonState extends State<PostCreateButton> {
  bool _isLoading;

  _PostCreateButtonState() : _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<PostCreateProvider>(
      builder: (context, postCreateP, child) => ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          height: 60,
          width: 120,
        ),
        child: ElevatedButton(
          onPressed: () async {
            if (_isLoading) return;
            if (!isInternetConnected(context)) return;
            if (!isProfileVerified(context)) return;
            setState(() => _isLoading = true);
            await postCreateP.getPostCreateHandler!();
            setState(() => _isLoading = false);
          },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).colorScheme.primaryContainer,
            onPrimary: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isLoading
                  ? LoadingAnimationWidget.horizontalRotatingDots(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 50,
                    )
                  : const Icon(
                      Icons.post_add_rounded,
                    ),
              if (!_isLoading) ...[
                const SizedBox(
                  width: 6,
                ),
                const Text(
                  'Post',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
