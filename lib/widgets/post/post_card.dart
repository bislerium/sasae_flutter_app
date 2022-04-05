import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/post/post_.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/normal_post_screen.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/poll_post_screen.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/request_post_screen.dart';

class PostCard extends StatelessWidget {
  final Post_ post;
  final bool isActionable;

  const PostCard({Key? key, required this.post, this.isActionable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      key: ValueKey(post.id),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Theme.of(context).colorScheme.inversePrimary,
        onTap: () {
          late String routeName;
          switch (post.postType) {
            case 'Normal':
              routeName = NormalPostScreen.routeName;
              break;
            case 'Poll':
              routeName = PollPostScreen.routeName;
              break;
            case 'Petition Request':
            case 'Join Request':
              routeName = RequestPostScreen.routeName;
              break;
          }
          Navigator.pushNamed(context, routeName,
              arguments: {'postID': post.id});
        },
        onLongPress: isActionable
            ? () {
                showModalSheet(
                  ctx: context,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Edit'),
                      onTap: () {},
                      shape: const StadiumBorder(),
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete_forever_rounded),
                      title: const Text('Delete'),
                      onTap: () {
                        showCustomDialog(
                          context: context,
                          title: 'Post Deletion',
                          content: 'Are you sure?\nCannot undo, once deleted.',
                          okFunc: () async {
                            bool success = await Provider.of<ProfileProvider>(
                                    context,
                                    listen: false)
                                .delete(postID: post.id);
                            if (success) {
                              showSnackBar(
                                context: context,
                                message: 'Deleted successfully.',
                              );
                            } else {
                              showSnackBar(
                                context: context,
                                message:
                                    'Unsuccessful deletion, Something went wrong!',
                                errorSnackBar: true,
                              );
                            }
                            Navigator.of(context)
                              ..pop()
                              ..pop();
                          },
                        );
                      },
                      shape: const StadiumBorder(),
                    ),
                  ],
                );
              }
            : null,
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
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                width: MediaQuery.of(context).size.width - 20,
                child: Text(
                  post.postContent,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  maxLines: 5,
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
                          label: post.postType.toLowerCase() ==
                                  PostType.normal.name
                              ? Icon(
                                  Icons.add_circle,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                )
                              : post.postType.toLowerCase() ==
                                      PostType.poll.name
                                  ? Icon(
                                      Icons.poll_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    )
                                  : Icon(
                                      Icons.front_hand_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
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
                              Icons.person_off_outlined,
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
