import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';
import 'package:sasae_flutter_app/services/utilities.dart';

class PollBarPollList extends StatefulWidget {
  final List<PollOptionModel> list;

  final Future<void> Function(int choice) pollCallBack;

  const PollBarPollList(
      {Key? key, required this.list, required this.pollCallBack})
      : super(key: key);

  @override
  State<PollBarPollList> createState() => _PollBarPollListState();
}

class _PollBarPollListState extends State<PollBarPollList> {
  bool _isLoading;

  _PollBarPollListState() : _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.list
          .map(
            (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: GestureDetector(
                  onTap: () async {
                    if (_isLoading) return;
                    if (!isInternetConnected(context)) return;
                    if (!isProfileVerified(context)) return;
                    setState(() => _isLoading = true);
                    await widget.pollCallBack(e.id);
                    setState(() => _isLoading = false);
                  },
                  child: RoundedProgressBar(
                    percent: 0,
                    style: RoundedProgressBarStyle(
                      colorBorder: Theme.of(context).colorScheme.surface,
                      borderWidth: 0,
                      widthShadow: 0,
                      backgroundProgress:
                          Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    childCenter: _isLoading
                        ? LoadingAnimationWidget.horizontalRotatingDots(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            size: 20,
                          )
                        : Text(
                            e.option,
                          ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                )),
          )
          .toList(),
    );
  }
}
