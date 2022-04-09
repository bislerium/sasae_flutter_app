import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_update_button.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_update_form.dart';

class PostUpdateFormScreen extends StatefulWidget {
  static const routeName = '/post/update/';
  final int postID;

  const PostUpdateFormScreen({Key? key, required this.postID})
      : super(key: key);

  @override
  State<PostUpdateFormScreen> createState() => _PostUpdateFormScreenState();
}

class _PostUpdateFormScreenState extends State<PostUpdateFormScreen> {
  late Future<void> _fetchrRelatedToOptionsFUTURE,
      _fetchNGOOptionsFUTURE,
      _fetchRetrieveUpdatePeopleFUTURE;
  late ScrollController _scrollController;
  late PostUpdateProvider _postUpdateP;
  late PostCreateProvider _postCreateP;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _postCreateP = Provider.of<PostCreateProvider>(context, listen: false);
    _postUpdateP = Provider.of<PostUpdateProvider>(context, listen: false);
    _fetchRetrieveUpdatePeopleFUTURE = _fetchRetrieveUpdatePeople();
    _fetchrRelatedToOptionsFUTURE = _fetchRelatedToOptions();
    _fetchNGOOptionsFUTURE = _fetchNGOOptions();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _postUpdateP.nullfyPerPostType();
    super.dispose();
  }

  Future<void> _fetchRelatedToOptions() async {
    await _postCreateP.initPostRelatedTo();
  }

  Future<void> _fetchNGOOptions() async {
    await _postCreateP.initNGOOptions();
  }

  Future<void> _fetchRetrieveUpdatePeople() async {
    await _postUpdateP.retrieveUpdatePost(postID: widget.postID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Update the Post'),
      body: FutureBuilder(
        future: Future.wait(<Future>[
          _fetchNGOOptionsFUTURE,
          _fetchrRelatedToOptionsFUTURE,
          _fetchRetrieveUpdatePeopleFUTURE,
        ]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const CustomLoading()
                : Consumer2<PostUpdateProvider, PostCreateProvider>(
                    builder: (context, postUpdateP, postCreateP, child) =>
                        postCreateP.getNGOOptionsData == null ||
                                postCreateP.getPostRelatedToData == null ||
                                postUpdateP.getUpdatePostType == null
                            ? const FetchError()
                            : PostUpdateForm(
                                snapshotNGOList: postCreateP.getNGOOptionsData!,
                                snapshotRelatedList:
                                    postCreateP.getPostRelatedToData!,
                                scrollController: _scrollController,
                              ),
                  ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer2<PostUpdateProvider, PostCreateProvider>(
        builder: (context, postUpdateP, postCreateP, child) =>
            postCreateP.getNGOOptionsData == null ||
                    postCreateP.getPostRelatedToData == null ||
                    postUpdateP.getUpdatePostType == null
                ? const SizedBox.shrink()
                : PostUpdateButton(
                    scrollController: _scrollController,
                  ),
      ),
    );
  }
}
