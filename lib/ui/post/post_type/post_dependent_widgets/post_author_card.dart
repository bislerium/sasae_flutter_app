import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';

class PostAuthorCard extends StatefulWidget {
  final String author;
  const PostAuthorCard({Key? key, required this.author}) : super(key: key);

  @override
  State<PostAuthorCard> createState() => _PostAuthorCardState();
}

class _PostAuthorCardState extends State<PostAuthorCard> {
  bool hidePostAuthor;

  _PostAuthorCardState() : hidePostAuthor = true;

  void toggleHidePostAuthor() => setState(() {
        hidePostAuthor ? hidePostAuthor = false : hidePostAuthor = true;
      });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: EdgeInsets.zero,
      borderRadius: 30,
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(30),
        onTap: toggleHidePostAuthor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(
                Icons.remove_red_eye,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                width: 20,
              ),
              Tooltip(
                message:
                    'Don\'t judge, bias, or ignore the post\n based on the author!',
                preferBelow: false,
                verticalOffset: 30,
                showDuration: const Duration(seconds: 2),
                child: Text(
                  'Author?',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: !hidePostAuthor,
                  child: Text(
                    widget.author,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
