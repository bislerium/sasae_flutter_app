import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_scroll_animated_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class RequestFAB extends StatefulWidget {
  final int postID;
  final ScrollController scrollController;
  final String requestType;
  final DateTime endsOn;
  final bool isRequestConsidered;

  const RequestFAB({
    Key? key,
    required this.postID,
    required this.scrollController,
    required this.isRequestConsidered,
    required this.requestType,
    required this.endsOn,
  }) : super(key: key);

  @override
  State<RequestFAB> createState() => _RequestFABState();
}

class _RequestFABState extends State<RequestFAB> {
  bool _isLoading;
  _RequestFABState() : _isLoading = false;

  Future<void> request() async {
    if (_isLoading) return;
    if (widget.isRequestConsidered) {
      showSnackBar(
          context: context,
          message: widget.requestType == 'Petition'
              ? 'Already signed'
              : 'Already Joined',
          errorSnackBar: true);
      return;
    }
    if (DateTime.now().isAfter(widget.endsOn)) {
      showSnackBar(
        context: context,
        message: '${widget.requestType} request expired',
        errorSnackBar: true,
      );
      return;
    }
    showCustomDialog(
      context: context,
      content: 'Once participated, You cannot undo!',
      okFunc: () async {
        Navigator.of(context).pop();
        setState(() => _isLoading = true);
        var success =
            await Provider.of<RequestPostProvider>(context, listen: false)
                .considerRequest();
        setState(() => _isLoading = false);
        if (!success) {
          showSnackBar(
            context: context,
            errorSnackBar: true,
          );
        }
      },
      title: 'Confirm ${widget.requestType}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollAnimatedFAB(
      scrollController: widget.scrollController,
      child: SizedBox(
        width: 120,
        height: 60,
        child: FloatingActionButton(
          onPressed: () async => request(),
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
                  : widget.requestType == 'Petition'
                      ? const Icon(Icons.gesture)
                      : const Icon(Icons.handshake_rounded),
              if (!_isLoading) ...[
                const SizedBox(
                  width: 6,
                ),
                Text(
                  widget.requestType == 'Petition'
                      ? widget.isRequestConsidered
                          ? 'Signed'
                          : 'Sign'
                      : widget.isRequestConsidered
                          ? 'Joined'
                          : 'Join',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
