import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
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
        child: FloatingActionButton.large(
          onPressed: () async {
            if (_isLoading) return;
            if (!isInternetConnected(context)) return;
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
          tooltip: 'Done',
          enableFeedback: true,
          child: _isLoading
              ? LoadingAnimationWidget.horizontalRotatingDots(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 50,
                )
              : const Icon(
                  Icons.done_rounded,
                ),
        ),
      ),
    );
  }
}
