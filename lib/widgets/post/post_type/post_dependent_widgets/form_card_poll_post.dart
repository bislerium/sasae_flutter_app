import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/dismissable_tile.dart';

class FormCardPollPost extends StatefulWidget {
  final List<String> pollItems;

  const FormCardPollPost({Key? key, required this.pollItems}) : super(key: key);

  @override
  _FormCardPollPostState createState() => _FormCardPollPostState();
}

class _FormCardPollPostState extends State<FormCardPollPost> {
  _FormCardPollPostState()
      : itemTEC = TextEditingController(),
        _formKey = GlobalKey<FormBuilderState>();

  final TextEditingController itemTEC;
  final GlobalKey<FormBuilderState> _formKey;

  @override
  void dispose() {
    itemTEC.dispose();
    super.dispose();
  }

  void addItem(String item) => setState(() {
        widget.pollItems.add(item.trim());
      });

  void removeItem(String item) => setState(() {
        widget.pollItems.remove(item);
      });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                FormBuilder(
                  key: _formKey,
                  child: Expanded(
                    child: FormBuilderTextField(
                      name: 'age',
                      controller: itemTEC,
                      decoration: const InputDecoration(
                        labelText: 'Option',
                        hintText: 'Add poll option',
                      ),
                      maxLength: 30,
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(context),
                          (value) => widget.pollItems.any((element) =>
                                  element.toLowerCase() ==
                                  value!.trim().toLowerCase())
                              ? 'The poll option is already added.'
                              : null,
                        ],
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 80, height: 50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addItem(itemTEC.text);
                        itemTEC.clear();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
            if (widget.pollItems.isNotEmpty)
              const SizedBox(
                height: 10,
              ),
            Column(
              children: widget.pollItems
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: DissmissableTile(
                        item: e,
                        removeHandler: (value) => removeItem(e),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
