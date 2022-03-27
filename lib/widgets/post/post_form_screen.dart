import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/api_config.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_bar.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_form.dart';

class PostFormScreen extends StatefulWidget {
  static const routeName = '/post/form';

  const PostFormScreen({Key? key}) : super(key: key);

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  late Future<void> _fetchrRelatedToOptionsFUTURE;
  late Future<void> _fetchNGOOptionsFUTURE;
  Future<void> Function()? postHandler;

  @override
  void initState() {
    super.initState();
    _fetchrRelatedToOptionsFUTURE = _fetchRelatedToOptions();
    _fetchNGOOptionsFUTURE = _fetchNGOOptions();
  }

  Future<void> _fetchRelatedToOptions() async {
    await Provider.of<PostProvider>(context, listen: false).initPostRelatedTo();
  }

  Future<void> _fetchNGOOptions() async {
    await Provider.of<PostProvider>(context, listen: false).initNGOOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Post a Post'),
      body: FutureBuilder(
        future: Future.wait(<Future>[
          _fetchNGOOptionsFUTURE,
          _fetchrRelatedToOptionsFUTURE,
        ]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const CustomLoading()
                : Consumer<PostProvider>(
                    builder: (context, postP, child) =>
                        postP.getNGOOptionsData == null ||
                                postP.getPostRelatedToData == null
                            ? const FetchError()
                            : PostForm(
                                snapshotNGOList: postP.getNGOOptionsData!,
                                snapshotRelatedList:
                                    postP.getPostRelatedToData!,
                              ),
                  ),
      ),
      bottomNavigationBar: Consumer<PostProvider>(
        builder: (context, postP, child) => postP.getNGOOptionsData == null ||
                postP.getPostRelatedToData == null
            ? const SizedBox.shrink()
            : const PostBar(),
      ),
    );
  }
}
