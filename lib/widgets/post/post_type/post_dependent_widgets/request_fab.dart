import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class RequestFAB extends StatefulWidget {
  final int postID;
  final ScrollController scrollController;
  final String requestType;
  final DateTime endsOn;
  final bool isParticipated;
  final VoidCallback handler;

  const RequestFAB({
    Key? key,
    required this.postID,
    required this.scrollController,
    required this.isParticipated,
    required this.requestType,
    required this.endsOn,
    required this.handler,
  }) : super(key: key);

  @override
  _RequestFABState createState() => _RequestFABState();
}

class _RequestFABState extends State<RequestFAB> {
  late bool isParticipated;

  @override
  void initState() {
    super.initState();
    isParticipated = widget.isParticipated;
  }

  Future<void> participate(BuildContext context) async {
    if (isParticipated) {
      showSnackBar(
          context: context,
          message: widget.requestType == 'Petition'
              ? 'Already signed!'
              : 'Already joined!',
          errorSnackBar: true);
      return;
    }

    if (DateTime.now().isAfter(widget.endsOn)) {
      showSnackBar(
        context: context,
        message: '${widget.requestType} request expired!',
        errorSnackBar: true,
      );
      return;
    }
    late String message;
    if (widget.requestType == 'Petition') {
      await signPetition();
      message = 'signed';
    }
    if (widget.requestType == 'Join') {
      await joinForm();
      message = 'joined';
    }
    isParticipated = true;
    widget.handler();
    showSnackBar(
      context: context,
      message: 'Successfully $message!',
    );
  }

  Future<void> signPetition() async {}

  Future<void> joinForm() async {}

  @override
  Widget build(BuildContext context) {
    return CustomFAB(
      text: widget.requestType == 'Petition'
          ? isParticipated
              ? 'Signed'
              : 'Sign'
          : isParticipated
              ? 'Joined'
              : 'Join',
      icon: widget.requestType == 'Petition'
          ? Icons.gesture
          : Icons.emoji_people_rounded,
      func: () => participate(context),
      scrollController: widget.scrollController,
    );
  }
}
