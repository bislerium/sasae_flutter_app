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
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Dismissible(
        key: Key(item),
        direction: DismissDirection.startToEnd,
        background: Container(
          color: Theme.of(context).colorScheme.error,
          child: Row(
            children: [
              const SizedBox(
                width: 14,
              ),
              Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.onError,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                'Remove',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
            ],
          ),
        ),
        onDismissed: (direction) {
          removeHandler(item);
          showSnackBar(context: context, message: '$item removed');
        },
        child: Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.primaryContainer,
          padding: const EdgeInsets.all(10),
          height: 54,
          child: Center(
            child: Text(
              item,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
