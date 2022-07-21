import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/providers/visibility_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/ui/post/module/post_list.dart';

class NGOProfilePostTab extends StatefulWidget {
  final int userID;
  final UserType userType;
  final ScrollController? scrollController;
  final bool actionablePost;
  const NGOProfilePostTab(
      {Key? key,
      required this.userID,
      required this.userType,
      this.scrollController,
      this.actionablePost = false})
      : super(key: key);

  @override
  State<NGOProfilePostTab> createState() => _NGOProfilePostTabState();
}

class _NGOProfilePostTabState extends State<NGOProfilePostTab>
    with AutomaticKeepAliveClientMixin {
  late final Future<void> _fetchUserPostFUTURE;
  late final NGOProfilePostProvider _ngoProfilePostP;

  @override
  void initState() {
    super.initState();
    _ngoProfilePostP =
        Provider.of<NGOProfilePostProvider>(context, listen: false);
    _fetchUserPostFUTURE = fetchProfilePost();
    widget.scrollController?.addListener(postPaginationListenScroll);
  }

  @override
  void dispose() {
    _ngoProfilePostP.resetProfilePosts();
    widget.scrollController?.removeListener(postPaginationListenScroll);
    super.dispose();
  }

  // To Override
  Future<void> fetchProfilePost() async {
    _ngoProfilePostP.setURL(userID: widget.userID, userType: widget.userType);
    await _ngoProfilePostP.fetchProfilePosts();
  }

  // To Override
  Future<void> refreshProfilePost() async {
    _ngoProfilePostP.setURL(userID: widget.userID, userType: widget.userType);
    _ngoProfilePostP.refreshProfilePosts();
  }

  void postPaginationListenScroll() {
    if (widget.scrollController?.position.maxScrollExtent ==
        widget.scrollController?.offset) {
      _ngoProfilePostP.fetchProfilePosts();
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
              : Consumer<NGOProfilePostProvider>(
                  builder: (context, profilePostP, child) => RefreshIndicator(
                    onRefresh: () async => await refreshCallBack(
                      context: context,
                      func: refreshProfilePost,
                    ),
                    child: profilePostP.getPosts == null
                        ? const ErrorView()
                        : profilePostP.getPosts!.isEmpty
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

class UserProfilePostTab extends StatefulWidget {
  final ScrollController? scrollController;
  final bool actionablePost;
  const UserProfilePostTab({
    Key? key,
    this.scrollController,
    this.actionablePost = false,
  }) : super(key: key);

  @override
  State<UserProfilePostTab> createState() => _UserProfilePostTabState();
}

class _UserProfilePostTabState extends State<UserProfilePostTab>
    with AutomaticKeepAliveClientMixin {
  late final Future<void> _fetchUserPostFUTURE;
  late final UserProfilePostProvider _userProfilePostP;
  late final NavigationBarProvider _navigationBarP;

  @override
  void initState() {
    super.initState();
    _userProfilePostP =
        Provider.of<UserProfilePostProvider>(context, listen: false);
    _navigationBarP =
        Provider.of<NavigationBarProvider>(context, listen: false);
    _fetchUserPostFUTURE = fetchProfilePost();
    widget.scrollController?.addListener(postPaginationListenScroll);
    widget.scrollController?.addListener(navigationBarListenScroll);
  }

  @override
  void dispose() {
    _userProfilePostP.resetProfilePosts();
    widget.scrollController?.removeListener(postPaginationListenScroll);
    widget.scrollController?.removeListener(navigationBarListenScroll);
    super.dispose();
  }

  Future<void> fetchProfilePost() async {
    _userProfilePostP.setURL();
    await _userProfilePostP.fetchProfilePosts();
  }

  Future<void> refreshProfilePost() async {
    _userProfilePostP.setURL();
    _userProfilePostP.refreshProfilePosts();
  }

  void postPaginationListenScroll() {
    if (widget.scrollController?.position.maxScrollExtent ==
        widget.scrollController?.offset) {
      _userProfilePostP.fetchProfilePosts();
    }
  }

  void navigationBarListenScroll() {
    var direction = widget.scrollController?.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      _navigationBarP.setShowNB = false;
    } else {
      _navigationBarP.setShowNB = true;
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
              : Consumer<UserProfilePostProvider>(
                  builder: (context, profilePostP, child) => RefreshIndicator(
                    onRefresh: () async => await refreshCallBack(
                      context: context,
                      func: refreshProfilePost,
                    ),
                    child: profilePostP.getPosts == null
                        ? const ErrorView()
                        : profilePostP.getPosts!.isEmpty
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
