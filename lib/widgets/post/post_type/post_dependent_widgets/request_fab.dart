import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_scroll_animated_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class RequestFAB extends StatelessWidget {
  final int postID;
  final ScrollController scrollController;
  final String requestType;
  final DateTime endsOn;
  final bool isParticipated;

  const RequestFAB({
    Key? key,
    required this.postID,
    required this.scrollController,
    required this.isParticipated,
    required this.requestType,
    required this.endsOn,
  }) : super(key: key);

  Future<void> participate(BuildContext context) async {
    if (isParticipated) {
      showSnackBar(
          context: context,
          message:
              requestType == 'Petition' ? 'Already signed!' : 'Already joined!',
          errorSnackBar: true);
      return;
    }
    if (DateTime.now().isAfter(endsOn)) {
      showSnackBar(
        context: context,
        message: '$requestType request expired!',
        errorSnackBar: true,
      );
      return;
    }
    late String message;
    if (requestType == 'Petition') {
      message = 'signed';
    }
    if (requestType == 'Join') {
      message = 'joined';
    }
    showCustomDialog(
      context: context,
      content: 'Once participated, You cannot undo!',
      okFunc: () async {
        var success =
            await Provider.of<RequestPostProvider>(context, listen: false)
                .participateRequest();
        success
            ? showSnackBar(
                context: context,
                message: 'Successfully $message!',
              )
            : showSnackBar(
                context: context,
                message: 'Something went wrong.',
                errorSnackBar: true,
              );
        Navigator.of(context).pop();
      },
      title: 'Confirm $requestType',
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollAnimatedFAB(
      text: requestType == 'Petition'
          ? isParticipated
              ? 'Signed'
              : 'Sign'
          : isParticipated
              ? 'Joined'
              : 'Join',
      icon: requestType == 'Petition' ? Icons.gesture : Icons.handshake,
      func: () async => participate(context),
      scrollController: scrollController,
    );
  }
}
