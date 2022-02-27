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
      key: Key(item),
      direction: DismissDirection.startToEnd,
      background: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Remove',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        removeHandler(item);
        showSnackBar(context: context, message: 'Item: $item removed!');
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        padding: const EdgeInsets.all(10),
        height: 50,
        child: Center(
          child: Text(
            item,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
