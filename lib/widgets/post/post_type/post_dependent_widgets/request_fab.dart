import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  late bool showFAB;
  late bool isParticipated;

  @override
  void initState() {
    super.initState();
    showFAB = true;
    isParticipated = widget.isParticipated;
    widget.scrollController.addListener(listenScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(listenScroll);
    super.dispose();
  }

  void listenScroll() {
    var direction = widget.scrollController.position.userScrollDirection;
    direction == ScrollDirection.reverse ? hide() : show();
  }

  void show() {
    if (!showFAB) setState(() => showFAB = true);
  }

  void hide() {
    if (showFAB) setState(() => showFAB = false);
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
    return Visibility(
      visible: showFAB,
      child: CustomFAB(
        text: widget.requestType == 'Petition' ? 'Sign' : 'Join',
        icon: widget.requestType == 'Petition'
            ? Icons.gesture
            : Icons.emoji_people_rounded,
        func: () => participate(context),
      ),
    );
  }
}
