import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/post.dart';

class PostTile extends StatelessWidget {
  final Post post;

  const PostTile({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const whiteText = TextStyle(
      color: Colors.white,
    );
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: Theme.of(context).primaryColorLight,
          onTap: () {},
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
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Chip(
                              backgroundColor:
                                  Theme.of(context).primaryColorLight,
                              label: Text(
                                e,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark),
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
                              post.postType
                                  .split(' ')
                                  .map((l) => l[0])
                                  .join(' '),
                              style: whiteText,
                            ),
                            backgroundColor: Colors.purple,
                          ),
                          if (post.isPokedToNGO)
                            const Chip(
                              label: Text(
                                'N',
                                style: whiteText,
                              ),
                              backgroundColor: Colors.blue,
                            ),
                          if (post.isPostedAnonymously)
                            const Chip(
                              label: Text(
                                'A',
                                style: whiteText,
                              ),
                              backgroundColor: Colors.red,
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
      ),
    );
  }
}
