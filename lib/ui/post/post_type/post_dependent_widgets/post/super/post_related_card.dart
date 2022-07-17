import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/wrapped_chips.dart';

class PostRelatedCard extends StatelessWidget {
  final List<String> list;

  const PostRelatedCard({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Related to:',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            WrappedChips(
              key: ValueKey(list.hashCode),
              list: list,
              center: false,
            ),
          ],
        ),
      ),
    );
  }
}
