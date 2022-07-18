import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/post/post_.dart';
import 'package:sasae_flutter_app/providers/post_interface.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/post/form/post_update_form_screen.dart';
import 'package:sasae_flutter_app/ui/post/type/normal_post_screen.dart';
import 'package:sasae_flutter_app/ui/post/type/poll_post_screen.dart';
import 'package:sasae_flutter_app/ui/post/type/request_post_screen.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class PostList extends StatefulWidget {
  final IPost postInterface;
  final ScrollController? scrollController;
  final bool isActionable;

  const PostList(
      {Key? key,
      required this.postInterface,
      this.scrollController,
      this.isActionable = false})
      : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    var postData = widget.postInterface.getPosts!;
    return ListView.builder(
      key: ValueKey(widget.postInterface.getPosts.hashCode),
      controller: widget.scrollController,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: postData.length + 1,
      itemBuilder: ((context, index) {
        if (index < postData.length) {
          var post = postData[index];
          return PostCard(
            key: ValueKey(post.id),
            post: post,
            isActionable: widget.isActionable,
          );
        } else {
          return Center(
            child:
                widget.postInterface.getHasMore ? const ButtomLoading() : null,
          );
        }
      }),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class PostCard extends StatelessWidget {
  final Post_Model post;
  final bool isActionable;

  const PostCard({Key? key, required this.post, this.isActionable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      key: ValueKey(post.hashCode),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // splashColor: Theme.of(context).colorScheme.primaryContainer,
        // highlightColor: Theme.of(context).colorScheme.primaryContainer,
        onTap: () {
          if (!isInternetConnected(context)) return;
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
                      title: const Text('Update'),
                      onTap: () {
                        Navigator.of(context).pop();
                        if (!isInternetConnected(context)) return;
                        Navigator.pushNamed(
                          context,
                          PostUpdateFormScreen.routeName,
                          arguments: {
                            'postID': post.id,
                          },
                        );
                      },
                      shape: const StadiumBorder(),
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete_forever_rounded),
                      title: const Text('Delete'),
                      onTap: () {
                        showCustomDialog(
                          context: context,
                          title: 'Confirm Delete',
                          content: 'Are you sure? Cannot undo, once deleted.',
                          cancelFunc: () => Navigator.of(context)
                            ..pop()
                            ..pop(),
                          okFunc: () async {
                            if (!isInternetConnected(context)) return;
                            Navigator.of(context)
                              ..pop()
                              ..pop();
                            bool success = await Provider.of<ProfileProvider>(
                                    context,
                                    listen: false)
                                .deletePost(postID: post.id);
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
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            label: Text(
                              e,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Text(
                post.postContent,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
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
