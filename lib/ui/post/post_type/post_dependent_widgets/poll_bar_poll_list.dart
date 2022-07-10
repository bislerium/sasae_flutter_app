import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';
import 'package:sasae_flutter_app/providers/internet_connection_provider.dart';

class PollBarPollList extends StatelessWidget {
  final List<PollOptionModel> list;

  final Future<void> Function(int choice) pollCallBack;

  const PollBarPollList(
      {Key? key, required this.list, required this.pollCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: list
          .map(
            (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: GestureDetector(
                  onTap: () async {
                    if (!Provider.of<InternetConnetionProvider>(context,
                            listen: false)
                        .getConnectionStatusCallBack(context)
                        .call()) return;
                    await pollCallBack(e.id);
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
                    childCenter: Text(
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
