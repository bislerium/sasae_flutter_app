import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/internet_connection_provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_scroll_animated_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class ProfileUpdateButton extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final ScrollController scrollController;
  const ProfileUpdateButton(
      {Key? key, required this.formKey, required this.scrollController})
      : super(key: key);

  @override
  State<ProfileUpdateButton> createState() => _ProfileUpdateButtonState();
}

class _ProfileUpdateButtonState extends State<ProfileUpdateButton> {
  bool _isLoading;

  _ProfileUpdateButtonState() : _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<PeopleProvider>(
      builder: (context, peopleP, child) => peopleP.getPeopleUpdate == null
          ? const SizedBox.shrink()
          : CustomScrollAnimatedFAB(
              scrollController: widget.scrollController,
              child: FloatingActionButton.large(
                onPressed: () async {
                  if (_isLoading) return;
                  if (!Provider.of<InternetConnetionProvider>(context,
                          listen: false)
                      .getConnectionStatusCallBack(context)
                      .call()) return;
                  bool validForm = widget.formKey.currentState!.validate();
                  if (validForm) {
                    showCustomDialog(
                      context: context,
                      title: 'Confirm Update',
                      content:
                          'Don\'t forget to refresh your profile page, once updated.',
                      okFunc: () async {
                        widget.formKey.currentState!.save();
                        Navigator.of(context).pop();
                        setState(() => _isLoading = true);
                        bool success = await peopleP.updatePeople();
                        setState(() => _isLoading = false);
                        if (success) {
                          if (!mounted) return;
                          Navigator.of(context).pop();
                          showSnackBar(
                            context: context,
                            message: 'profile updated',
                          );
                        } else {
                          showSnackBar(context: context, errorSnackBar: true);
                        }
                      },
                    );
                  }
                },
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
