import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/post/post_form.dart';
import './post_list.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController;

  _PostScreenState() : scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder(
        future:
            Provider.of<PostProvider>(context, listen: false).intiFetchPosts(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      LinearProgressIndicator(),
                    ],
                  )
                : Consumer<PostProvider>(
                    builder: (context, postP, child) => RefreshIndicator(
                      onRefresh: postP.refreshPosts,
                      child: postP.postData == null
                          ? const FetchError()
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: PostList(
                                posts: postP.postData!,
                                scrollController: scrollController,
                              ),
                            ),
                    ),
                  ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<PostProvider>(
        builder: (context, postP, child) => postP.postData == null
            ? const SizedBox.shrink()
            : CustomFAB(
                text: 'Post',
                background: Theme.of(context).colorScheme.primary,
                icon: Icons.post_add,
                func: () => Navigator.pushNamed(context, PostForm.routeName),
                foreground: Theme.of(context).colorScheme.onPrimary,
                scrollController: scrollController,
              ),
      ),
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
