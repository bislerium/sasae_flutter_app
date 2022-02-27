import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class DissmissableTile extends StatelessWidget {
  final String item;
  final void Function(String) removeHandler;

  const DissmissableTile(
      {Key? key, required this.item, required this.removeHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // Each Dismissible must contain a Key. Keys allow Flutter to
      // uniquely identify widgets.
      key: Key(item),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Theme.of(context).colorScheme.error,
      ),
      onDismissed: (direction) {
        // Remove the item from the data source.
        removeHandler(item);
        // Then show a snackbar.
        showSnackBar(context: context, message: 'Item: $item removed!');
      },
      child: ListTile(
        title: Text(item),
      ),
    );
  }
}
