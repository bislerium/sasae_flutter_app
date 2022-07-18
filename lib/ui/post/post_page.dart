import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/post/form/post_create_form_screen.dart';
import 'package:sasae_flutter_app/ui/post/module/post_list.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController;
  late final Future<void> _fetchPostFUTURE;
  late final PostProvider postP;
  late final PostFABProvider _postFABP;

  _PostPageState() : _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    postP = Provider.of<PostProvider>(context, listen: false);
    _postFABP = Provider.of<PostFABProvider>(context, listen: false);
    _scrollController.addListener(postfabListenScroll);
    _scrollController.addListener(postPaginationListenScroll);
    _fetchPostFUTURE = _initFetchPost();
  }

  @override
  void dispose() {
    _scrollController.removeListener(postfabListenScroll);
    _scrollController.removeListener(postPaginationListenScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void postfabListenScroll() {
    var direction = _scrollController.position.userScrollDirection;
    direction == ScrollDirection.reverse
        ? _postFABP.setShowFAB = false
        : _postFABP.setShowFAB = true;
  }

  void postPaginationListenScroll() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      _fetchPosts();
    }
  }

  Future<void> _fetchPosts() async => await postP.fetchPosts();

  Future<void> _initFetchPost() async {
    await _fetchPosts();
    var data = postP.getPosts;
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (data == null) {
        _postFABP.setOnPressedHandler = null;
        _postFABP.setShowFAB = false;
      } else {
        _postFABP.setOnPressedHandler = () => Navigator.pushNamed(
            context, PostCreateFormScreen.routeName,
            arguments: {'isUpdateMode': false});
        _postFABP.setShowFAB = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _fetchPostFUTURE,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const ScreenLoading()
              : Consumer<PostProvider>(
                  builder: (context, postP, child) => RefreshIndicator(
                    onRefresh: () async => await refreshCallBack(
                      context: context,
                      func: postP.refreshPosts,
                    ),
                    child: postP.getPosts == null
                        ? const ErrorView()
                        : postP.getPosts!.isEmpty
                            ? const ErrorView(
                                errorMessage: 'No post yet 😒...',
                              )
                            : PostList(
                                postInterface: postP,
                                scrollController: _scrollController,
                              ),
                  ),
                ),
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
