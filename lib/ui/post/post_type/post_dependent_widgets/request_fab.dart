import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/internet_connection_provider.dart';
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

  Future<void> requestCallBack() async {
    if (_isLoading) return;
    if (!Provider.of<InternetConnetionProvider>(context, listen: false)
        .getConnectionStatusCallBack(context)
        .call()) return;
    if (widget.isRequestConsidered) {
      showSnackBar(
          context: context,
          message: widget.requestType == 'Petition'
              ? 'Already signed'
              : 'Already joined',
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
        if (!Provider.of<InternetConnetionProvider>(context, listen: false)
            .getConnectionStatusCallBack(context)
            .call()) return;
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
      child: FloatingActionButton.large(
        onPressed: requestCallBack,
        elevation: 3,
        child: _isLoading
            ? LoadingAnimationWidget.horizontalRotatingDots(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 50,
              )
            : widget.requestType == 'Petition'
                ? widget.isRequestConsidered
                    ? const Icon(Icons.draw)
                    : const Icon(Icons.draw_outlined)
                : widget.isRequestConsidered
                    ? const Icon(Icons.handshake_rounded)
                    : const Icon(Icons.handshake_outlined),
      ),
    );
  }
}
