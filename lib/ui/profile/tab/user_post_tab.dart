import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/ui/post/module/post_list.dart';

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
  late final ProfileProvider _profileP;
  late final ProfileSettingFABProvider _profileSettingFABP;

  @override
  void initState() {
    super.initState();
    _profileP = Provider.of<ProfileProvider>(context, listen: false);
    _profileSettingFABP =
        Provider.of<ProfileSettingFABProvider>(context, listen: false);
    _fetchUserPostFUTURE = _fetchProfilePost();
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(profleCreatefabListenScroll);
      widget.scrollController!.addListener(postPaginationListenScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(profleCreatefabListenScroll);
    widget.scrollController?.removeListener(postPaginationListenScroll);
    super.dispose();
  }

  Future<void> _fetchProfilePost() async {
    _profileP.setURL(
      userID: widget.userID,
      userType: widget.userType,
    );
    await _fetchPosts();
    print(_profileP.getPostData?.length);
  }

  Future<void> _fetchPosts() async => await _profileP.fetchUserPosts();

  void profleCreatefabListenScroll() {
    var direction = widget.scrollController!.position.userScrollDirection;
    direction == ScrollDirection.reverse
        ? _profileSettingFABP.setShowFAB = false
        : _profileSettingFABP.setShowFAB = true;
  }

  void postPaginationListenScroll() {
    if (widget.scrollController!.position.maxScrollExtent ==
        widget.scrollController!.offset) {
      _fetchPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _fetchUserPostFUTURE,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const ScreenLoading()
              : Consumer<ProfileProvider>(
                  builder: (context, profilePostP, child) => RefreshIndicator(
                    onRefresh: () async => await refreshCallBack(
                      context: context,
                      func: () async => await profilePostP.refreshUserPosts(
                        userID: widget.userID,
                        userType: widget.userType,
                      ),
                    ),
                    child: profilePostP.getPostData == null
                        ? const ErrorView()
                        : profilePostP.getPostData!.isEmpty
                            ? const ErrorView(
                                errorMessage: 'Nothing posted yet 😅...',
                              )
                            : PostList(
                                postInterface: profilePostP,
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
