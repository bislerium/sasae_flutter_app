import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/people.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';

class PeopleProfileEditForm extends StatefulWidget {
  final PeopleUpdateModel peopleUpdate;
  final ScrollController scrollController;
  final GlobalKey<FormBuilderState> formKey;

  const PeopleProfileEditForm(
      {Key? key,
      required this.peopleUpdate,
      required this.scrollController,
      required this.formKey})
      : super(key: key);

  @override
  State<PeopleProfileEditForm> createState() => _PeopleProfileEditFormState();
}

class _PeopleProfileEditFormState extends State<PeopleProfileEditForm> {
  Widget fullNameField() => FormBuilderTextField(
        name: 'update_fullName',
        decoration: const InputDecoration(
          labelText: 'Full name',
          icon: Icon(Icons.person),
        ),
        initialValue: widget.peopleUpdate.getFullname,
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
          ],
        ),
        keyboardType: TextInputType.name,
        onSaved: (value) => widget.peopleUpdate.setFullname = value,
      );

  Widget genderField() => FormBuilderDropdown(
        name: 'update_gender',
        decoration: const InputDecoration(
          labelText: 'Gender',
          icon: Icon(Icons.transgender),
        ),
        initialValue: widget.peopleUpdate.getGender,
        allowClear: true,
        hint: const Text(
          'Select your Gender',
        ),
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
          ],
        ),
        items: ['Male', 'Female', 'LGBTQ+']
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        onSaved: (value) => widget.peopleUpdate.setGender = value as String?,
      );

  Widget addressField() => FormBuilderTextField(
        name: 'update_address',
        decoration: const InputDecoration(
          labelText: 'Address',
          icon: Icon(Icons.location_city_rounded),
        ),
        initialValue: widget.peopleUpdate.getAddress,
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
          ],
        ),
        keyboardType: TextInputType.text,
        onSaved: (value) => widget.peopleUpdate.setAddress = value,
      );

  Widget birthDateField() => FormBuilderDateTimePicker(
        name: 'update_birthDate',
        inputType: InputType.date,
        decoration: const InputDecoration(
          labelText: 'Birthdate',
          icon: Icon(Icons.cake_rounded),
        ),
        initialValue: widget.peopleUpdate.getBirthDate,
        firstDate: DateTime.now().subtract(const Duration(days: 365 * 122)),
        lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
          ],
        ),
        onSaved: (value) => widget.peopleUpdate.setBirthDate = value,
      );

  Widget emailField() => FormBuilderTextField(
        name: 'update_email',
        decoration: const InputDecoration(
          labelText: 'Email',
          icon: Icon(Icons.email_rounded),
        ),
        initialValue: widget.peopleUpdate.getEmail,
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ],
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onSaved: (value) => widget.peopleUpdate.setEmail = value,
      );

  Widget phoneField() => FormBuilderTextField(
        name: 'update_phone',
        decoration: const InputDecoration(
          labelText: 'Phone number',
          icon: Icon(Icons.phone_android_rounded),
        ),
        initialValue: widget.peopleUpdate.getPhone,
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
          ],
        ),
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        onSaved: (value) => widget.peopleUpdate.setPhone = value,
      );

  Widget displayPicture() => UpdatePicture(
        labelText: 'Display picture',
        picture: widget.peopleUpdate.getDisplayPicture,
        onSavedFunc: (list) => list == null || list.isEmpty
            ? widget.peopleUpdate.setDisplayPicture = null
            : widget.peopleUpdate.setDisplayPicture = list.first,
      );

  Widget citizenshipPhoto() => UpdatePicture(
        labelText: 'Citizenship photo',
        picture: widget.peopleUpdate.getCitizenshipPhoto,
        onSavedFunc: (list) => list == null || list.isEmpty
            ? widget.peopleUpdate.setCitizenshipPhoto = null
            : widget.peopleUpdate.setCitizenshipPhoto = list.first,
        enabled: !widget.peopleUpdate.getIsverified!,
      );

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        controller: widget.scrollController,
        children: [
          displayPicture(),
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  fullNameField(),
                  const SizedBox(
                    height: 10,
                  ),
                  genderField(),
                  const SizedBox(
                    height: 10,
                  ),
                  addressField(),
                  const SizedBox(
                    height: 10,
                  ),
                  birthDateField(),
                  const SizedBox(
                    height: 10,
                  ),
                  phoneField(),
                  const SizedBox(
                    height: 10,
                  ),
                  emailField(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          citizenshipPhoto(),
        ],
      ),
    );
  }
}

class UpdatePicture extends StatelessWidget {
  final String labelText;
  final XFile? picture;
  final void Function(List<dynamic>?)? onSavedFunc;
  final bool enabled;

  const UpdatePicture(
      {Key? key,
      required this.labelText,
      this.picture,
      this.onSavedFunc,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 60;
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Consumer<PeopleProvider>(
          builder: (context, peopleP, child) => FormBuilderImagePicker(
            enabled: enabled,
            name: 'update_$labelText',
            initialValue: [picture],
            decoration: InputDecoration(
              labelText: labelText,
              border: InputBorder.none,
            ),
            iconColor: Theme.of(context).colorScheme.secondaryContainer,
            previewWidth: width,
            previewHeight: width,
            maxImages: 1,
            onSaved: onSavedFunc,
          ),
        ),
      ),
    );
  }
}
