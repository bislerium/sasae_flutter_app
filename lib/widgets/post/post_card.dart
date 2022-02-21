import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/normal_post_screen.dart';
import '../../models/post_.dart';

class PostCard extends StatelessWidget {
  final Post_ post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(post.id),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Theme.of(context).colorScheme.inversePrimary,
        onTap: () {
          Widget Function(BuildContext)? postScreenRedirection;
          if (post.postType == 'Normal Post') {
            postScreenRedirection =
                (context) => PostNormalScreen(hyperlink: post.postURL);
          }
          if (postScreenRedirection == null) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: postScreenRedirection,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: post.relatedTo
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Chip(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            label: Text(
                              e,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  post.postContent,
                  maxLines: 5,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            post.postType.split(' ').map((l) => l[0]).join(' '),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        if (post.isPokedToNGO)
                          Chip(
                            label: Text(
                              'N',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                            ),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                          ),
                        if (post.isPostedAnonymously)
                          Chip(
                            label: Text(
                              'A',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                      ],
                    ),
                    Text(DateFormat.yMMMd().format(post.postedOn))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
