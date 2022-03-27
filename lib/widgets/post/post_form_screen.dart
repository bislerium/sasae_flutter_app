import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';
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
    return FutureBuilder(
      future: Future.wait(<Future>[
        _fetchNGOOptionsFUTURE,
        _fetchrRelatedToOptionsFUTURE,
      ]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              LinearProgressIndicator(),
            ],
          );
        }
        if (snapshot.hasError) {
          showSnackBar(
            context: context,
            message: 'Something went wrong!',
            errorSnackBar: true,
          );
          Navigator.of(context).pop();
        }
        return Consumer<PostProvider>(
          builder: (context, postP, child) => PostForm(
              snapshotNGOList: postP.ngoOptions!,
              snapshotRelatedList: postP.postRelatedTo!),
        );
      },
    );
  }
}
