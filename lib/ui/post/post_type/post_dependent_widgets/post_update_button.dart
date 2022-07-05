import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_scroll_animated_fab.dart';

class PostUpdateButton extends StatefulWidget {
  final ScrollController scrollController;
  const PostUpdateButton({Key? key, required this.scrollController})
      : super(key: key);

  @override
  State<PostUpdateButton> createState() => _PostUpdateButtonState();
}

class _PostUpdateButtonState extends State<PostUpdateButton> {
  bool _isLoading;

  _PostUpdateButtonState() : _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<PostUpdateProvider>(
      builder: (context, postUpdateP, child) => CustomScrollAnimatedFAB(
        scrollController: widget.scrollController,
        child: SizedBox(
          width: 120,
          height: 60,
          child: FloatingActionButton(
            onPressed: () async {
              if (_isLoading) return;
              setState(() => _isLoading = true);
              await postUpdateP.getPostUpdateHandler!();
              setState(() => _isLoading = false);
            },
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isLoading
                    ? LoadingAnimationWidget.horizontalRotatingDots(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        size: 50,
                      )
                    : const Icon(
                        Icons.done_rounded,
                      ),
                if (!_isLoading) ...[
                  const SizedBox(
                    width: 6,
                  ),
                  const Text(
                    'Done',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
