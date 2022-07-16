import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/widgets/misc/annotated_scaffold.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/post_bar.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/post_create_form.dart';

class PostCreateFormScreen extends StatefulWidget {
  static const routeName = '/post/create/';

  const PostCreateFormScreen({Key? key}) : super(key: key);

  @override
  State<PostCreateFormScreen> createState() => _PostCreateFormScreenState();
}

class _PostCreateFormScreenState extends State<PostCreateFormScreen>
    with SingleTickerProviderStateMixin {
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
    await Provider.of<PostCreateProvider>(context, listen: false)
        .initPostRelatedTo();
  }

  Future<void> _fetchNGOOptions() async {
    await Provider.of<PostCreateProvider>(context, listen: false)
        .initNGOOptions();
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    return AnnotatedScaffold(
      systemNavigationBarColor: ElevationOverlay.colorWithOverlay(
          colors.surface, colors.primary, 3.0),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Post a Post'),
        body: FutureBuilder(
          future: Future.wait(<Future>[
            _fetchNGOOptionsFUTURE,
            _fetchrRelatedToOptionsFUTURE,
          ]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const ScreenLoading()
                  : Consumer<PostCreateProvider>(
                      builder: (context, postCreateP, child) =>
                          RefreshIndicator(
                        onRefresh: () async => await refreshCallBack(
                          context: context,
                          func: () async {
                            await postCreateP.refreshNGOOptions();
                            await postCreateP.refreshPostRelatedTo();
                          },
                        ),
                        child: postCreateP.getNGOOptionsData == null ||
                                postCreateP.getPostRelatedToData == null
                            ? const ErrorView()
                            : PostCreateForm(
                                snapshotNGOList: postCreateP.getNGOOptionsData!,
                                snapshotRelatedList:
                                    postCreateP.getPostRelatedToData!,
                              ),
                      ),
                    ),
        ),
        bottomNavigationBar: Consumer<PostCreateProvider>(
          builder: (context, postCreateP, child) =>
              postCreateP.getNGOOptionsData == null ||
                      postCreateP.getPostRelatedToData == null
                  ? const SizedBox.shrink()
                  : const PostBar(),
        ),
      ),
    );
  }
}
