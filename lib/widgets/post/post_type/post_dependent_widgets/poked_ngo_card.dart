import 'package:flutter/material.dart';

import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';

import '../../../misc/custom_widgets.dart';

class PokedNGOCard extends StatelessWidget {
  final List<NGO__> list;
  const PokedNGOCard({Key? key, required this.list}) : super(key: key);

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
              'Poked NGO:',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            getWrappedClickableChips(
              context: context,
              list: list,
            ),
          ],
        ),
      ),
    );
  }
}
