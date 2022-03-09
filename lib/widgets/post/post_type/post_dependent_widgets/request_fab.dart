import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class RequestFAB extends StatelessWidget {
  final int postID;
  final ScrollController scrollController;
  final String requestType;
  final DateTime endsOn;
  final bool isParticipated;
  final Future<bool> Function() handler;

  const RequestFAB({
    Key? key,
    required this.postID,
    required this.scrollController,
    required this.isParticipated,
    required this.requestType,
    required this.endsOn,
    required this.handler,
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
    await handler()
        ? showSnackBar(
            context: context,
            message: 'Successfully $message!',
          )
        : showSnackBar(
            context: context,
            message: 'Something went wrong.',
            errorSnackBar: true,
          );
  }

  @override
  Widget build(BuildContext context) {
    return CustomFAB(
      text: requestType == 'Petition'
          ? isParticipated
              ? 'Signed'
              : 'Sign'
          : isParticipated
              ? 'Joined'
              : 'Join',
      icon: requestType == 'Petition'
          ? Icons.gesture
          : Icons.emoji_people_rounded,
      func: () => participate(context),
      scrollController: scrollController,
    );
  }
}
