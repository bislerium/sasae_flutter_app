import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/post/post_list.dart';

class UserPostTab extends StatefulWidget {
  final ScrollController? scrollController;
  final int? userID;
  final UserType? userType;
  final bool actionablePost;
  const UserPostTab(
      {Key? key,
      this.scrollController,
      this.userID,
      this.userType,
      this.actionablePost = false})
      : super(key: key);

  @override
  State<UserPostTab> createState() => _UserPostTabState();
}

class _UserPostTabState extends State<UserPostTab>
    with AutomaticKeepAliveClientMixin {
  late final Future<void> _fetchUserPostFUTURE;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(profleCreatefabListenScroll);
    }
    _fetchUserPostFUTURE = _fetchProfilePost();
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(profleCreatefabListenScroll);
    super.dispose();
  }

  Future<void> _fetchProfilePost() async {
    var pProvider = Provider.of<ProfileProvider>(context, listen: false);
    await pProvider.intiFetchUserPosts(
      userID: widget.userID,
      userType: widget.userType,
    );
  }

  void profleCreatefabListenScroll() {
    var _ = Provider.of<ProfileSettingFABProvider>(context, listen: false);
    var direction = widget.scrollController!.position.userScrollDirection;
    direction == ScrollDirection.reverse
        ? _.setShowFAB = false
        : _.setShowFAB = true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _fetchUserPostFUTURE,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const CustomLoading()
              : Consumer<ProfileProvider>(
                  builder: (context, profilePostP, child) => RefreshIndicator(
                    onRefresh: () async => profilePostP.refreshUserPosts(
                      userID: widget.userID,
                      userType: widget.userType,
                    ),
                    child: profilePostP.getUserPostData == null
                        ? const FetchError()
                        : profilePostP.getUserPostData!.isEmpty
                            ? const FetchError(
                                errorMessage: 'No post yet... 😅',
                              )
                            : PostList(
                                posts: profilePostP.getUserPostData!,
                                scrollController: widget.scrollController,
                                isActionable: widget.actionablePost,
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