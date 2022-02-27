import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

import 'post_type/post_dependent_widgets/form_card_normal_post.dart';
import 'post_type/post_dependent_widgets/form_card_poll_post.dart';

class PostForm extends StatefulWidget {
  static const routeName = '/postform';

  const PostForm({Key? key}) : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  _PostFormState()
      : pollItems = [],
        descriptionKey = GlobalKey<FormState>();
  final GlobalKey<FormState> descriptionKey;
  final List<String> pollItems;

  @override
  Widget build(BuildContext context) {
    Color iconColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Post a Post'),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            TextFormField(
              // controller: descriptionField,
              decoration: const InputDecoration(
                label: Text('Description'),
                hintText: "What's your post about?",
                alignLabelWithHint: true,
                icon: Icon(Icons.description_rounded),
              ),
              validator: (value) {
                return checkValue(
                  value: value,
                  checkEmptyOnly: true,
                );
              },
              maxLength: 500,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 10,
            ),
            const FormCardNormalPost(),
            FormCardPollPost(
              pollItems: pollItems,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.file_present_rounded,
                      color: iconColor,
                    ),
                    iconSize: 35,
                    tooltip: 'Normal Post',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.poll_rounded,
                      color: iconColor,
                    ),
                    iconSize: 35,
                    tooltip: 'Poll Post',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.help_center,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    iconSize: 35,
                    tooltip: 'Request Post',
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Material(
                    type: MaterialType.button,
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.error,
                    child: IconButton(
                      icon: const Icon(Icons.clear_all_rounded),
                      color: Theme.of(context).colorScheme.onError,
                      onPressed: () {},
                      tooltip: 'Clear all Field',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(
                      height: 50,
                      width: 120,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.post_add_rounded,
                      ),
                      label: const Text(
                        'Post',
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
