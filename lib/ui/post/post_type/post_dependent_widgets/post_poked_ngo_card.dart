import 'package:flutter/material.dart';

import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/ui/ngo/ngo_profile_screen.dart';

class PokedNGOCard extends StatelessWidget {
  final List<NGO__Model> list;
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
            Wrap(
              spacing: 8,
              runSpacing: -5,
              children: list
                  .map(
                    (e) => ActionChip(
                        key: ValueKey(e.id),
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        avatar: CircleAvatar(
                          backgroundImage: NetworkImage(
                            e.orgPhoto,
                          ),
                        ),
                        label: Text(
                          e.orgName,
                          style:
                              Theme.of(context).textTheme.subtitle2?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                  ),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        pressElevation: 2,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            NGOProfileScreen.routeName,
                            arguments: {'ngoID': e.id},
                          );
                        }),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
