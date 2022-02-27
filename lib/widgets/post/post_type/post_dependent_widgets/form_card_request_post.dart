import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormCardRequestPost extends StatefulWidget {
  const FormCardRequestPost({Key? key}) : super(key: key);

  @override
  _FormCardRequestPostState createState() => _FormCardRequestPostState();
}

class _FormCardRequestPostState extends State<FormCardRequestPost> {
  List<String> requestType;

  _FormCardRequestPostState() : requestType = ['Join', 'Petition'];

  @override
  Widget build(BuildContext context) {
    var dateTime = DateTime.now();

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: 'min',
                    decoration: const InputDecoration(
                      labelText: 'Minimum',
                    ),
                    onChanged: (value) {},
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.numeric(context),
                      FormBuilderValidators.max(context, 70),
                    ]),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderTextField(
                    name: 'target',
                    decoration: const InputDecoration(
                      labelText: 'Target',
                    ),
                    onChanged: (value) {},
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.numeric(context),
                        FormBuilderValidators.max(context, 70),
                      ],
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: 'max',
                    decoration: const InputDecoration(
                      labelText: 'Maximum',
                    ),
                    onChanged: (value) {},
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.numeric(context),
                      FormBuilderValidators.max(context, 70),
                    ]),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderDropdown(
                    name: 'requestType',
                    decoration: const InputDecoration(
                      labelText: 'Request type',
                    ),
                    allowClear: true,
                    hint: const Text(
                      'Select type',
                    ),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    items: requestType
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FormBuilderDateTimePicker(
              name: 'Request duration',
              inputType: InputType.both,
              decoration: const InputDecoration(
                labelText: 'End Time',
              ),
              initialValue: dateTime,
              firstDate: dateTime,
            ),
          ],
        ),
      ),
    );
  }
}
