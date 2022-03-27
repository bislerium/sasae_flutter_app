import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/post/post_form_screen.dart';
import './post_list.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController;
  late final Future<void> _fetchPostFUTURE;

  _PostScreenState() : _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchPostFUTURE = _fetchPost();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchPost() async {
    await Provider.of<PostProvider>(context, listen: false).intiFetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder(
        future: _fetchPostFUTURE,
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
                          : postP.postData!.isEmpty
                              ? const FetchError(
                                  errorMessage: 'No post yet... 😅',
                                )
                              : PostList(
                                  posts: postP.postData!,
                                  scrollController: _scrollController,
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
                func: () =>
                    Navigator.pushNamed(context, PostFormScreen.routeName),
                foreground: Theme.of(context).colorScheme.onPrimary,
                scrollController: _scrollController,
              ),
      ),
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
