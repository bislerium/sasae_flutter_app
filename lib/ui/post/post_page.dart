import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/ui/post/post_create_form_screen.dart';
import 'module/post_list.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController;
  late final Future<void> _fetchPostFUTURE;

  _PostPageState() : _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(postfabListenScroll);
    _fetchPostFUTURE = _fetchPost();
  }

  @override
  void dispose() {
    _scrollController.removeListener(postfabListenScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void postfabListenScroll() {
    var _ = Provider.of<PostFABProvider>(context, listen: false);
    var direction = _scrollController.position.userScrollDirection;
    direction == ScrollDirection.reverse
        ? _.setShowFAB = false
        : _.setShowFAB = true;
  }

  Future<void> _fetchPost() async {
    var pProvider = Provider.of<PostProvider>(context, listen: false);
    await pProvider.intiFetchPosts();
    var data = pProvider.getPostData;
    var pfProvider = Provider.of<PostFABProvider>(context, listen: false);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (data == null) {
        pfProvider.setOnPressedHandler = null;
        pfProvider.setShowFAB = false;
      } else {
        pfProvider.setOnPressedHandler = () => Navigator.pushNamed(
            context, PostCreateFormScreen.routeName,
            arguments: {'isUpdateMode': false});
        pfProvider.setShowFAB = true;
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
              ? const CustomLoading()
              : Consumer<PostProvider>(
                  builder: (context, postP, child) => RefreshIndicator(
                    onRefresh: postP.refreshPosts,
                    child: postP.getPostData == null
                        ? const FetchError()
                        : postP.getPostData!.isEmpty
                            ? const FetchError(
                                errorMessage: 'No post yet... 😅',
                              )
                            : PostList(
                                posts: postP.getPostData!,
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
