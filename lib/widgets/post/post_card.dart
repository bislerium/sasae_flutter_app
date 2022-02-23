import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import './post_type/normal_post_screen.dart';
import '../../models/post/post_.dart';

class PostCard extends StatelessWidget {
  final Post_ post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      key: ValueKey(post.id),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
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
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  maxLines: 5,
                  // textAlign: TextAlign.justify,
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
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        if (post.isPokedToNGO) ...[
                          const SizedBox(
                            width: 10,
                          ),
                          Chip(
                            label: Icon(
                              Icons.health_and_safety_outlined,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                          ),
                        ],
                        if (post.isPostedAnonymously) ...[
                          const SizedBox(
                            width: 10,
                          ),
                          Chip(
                            label: Icon(
                              Icons.person_off,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                        ],
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
