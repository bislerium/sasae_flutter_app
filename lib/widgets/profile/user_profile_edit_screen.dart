import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sasae_flutter_app/models/user.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';

class UserProfileEditScreen extends StatefulWidget {
  static const String routeName = '/profile/edit';

  final User user;
  const UserProfileEditScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _UserProfileEditScreenState createState() => _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends State<UserProfileEditScreen> {
  ScrollController scrollController;
  GlobalKey<FormBuilderState> formKey;
  _UserProfileEditScreenState()
      : scrollController = ScrollController(),
        formKey = GlobalKey<FormBuilderState>();

  Widget displayPhotoField() {
    double width = MediaQuery.of(context).size.width - 30;
    return FormBuilderImagePicker(
      name: 'displayPicture',
      initialValue: [widget.user.displayPicture],
      decoration: const InputDecoration(
        labelText: 'Display Picture',
        border: InputBorder.none,
      ),
      previewWidth: width,
      previewHeight: width,
      maxImages: 1,
    );
  }

  Widget fullNameField() => FormBuilderTextField(
        name: 'fullName',
        // controller: targetTEC,
        decoration: const InputDecoration(
          labelText: 'Full Name',
        ),
        initialValue: widget.user.fullName,
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(context),
          ],
        ),
        keyboardType: TextInputType.name,
      );

  Widget genderField() => FormBuilderDropdown(
        name: 'gender',
        decoration: const InputDecoration(
          labelText: 'Gender',
        ),
        initialValue: widget.user.gender,
        hint: const Text(
          'Select gender',
        ),
        // onChanged: (value) => requestTypeTEC = value as String?,
        validator: FormBuilderValidators.compose(
            [FormBuilderValidators.required(context)]),
        items: const [
          DropdownMenuItem(
            value: 'Male',
            child: Text('Male'),
          ),
          DropdownMenuItem(
            value: 'Female',
            child: Text('Female'),
          ),
          DropdownMenuItem(
            value: 'LGBTQ+',
            child: Text('LGBTQ+'),
          )
        ],
      );

  Widget birthDateField() => FormBuilderDateTimePicker(
        name: 'birthDate',
        // controller: endsOnTEC,
        inputType: InputType.date,
        decoration: const InputDecoration(
          labelText: 'Birth Date',
        ),
        initialValue: widget.user.birthDate,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(context),
        ]),
        lastDate: DateTime.now(),
      );

  Widget emailField() => FormBuilderTextField(
        name: 'email',
        // controller: targetTEC,
        decoration: const InputDecoration(
          labelText: 'Email',
        ),
        initialValue: widget.user.email,
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(context),
            FormBuilderValidators.email(context),
          ],
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      );

  Widget phoneField() => FormBuilderTextField(
        name: 'phone',
        // controller: targetTEC,
        decoration: const InputDecoration(
          labelText: 'Phone number',
        ),
        initialValue: widget.user.phoneNumber,
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(context),
          ],
        ),
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
      );

  Widget citizenshipPhotoField() {
    double width = MediaQuery.of(context).size.width - 30;
    return FormBuilderImagePicker(
      name: 'citizenship',
      initialValue: [widget.user.citizenshipPhoto],
      decoration: const InputDecoration(
        labelText: 'Attach a citizenship photo',
        border: InputBorder.none,
      ),
      previewWidth: width,
      previewHeight: width,
      maxImages: 1,
    );
  }

  Widget fab() => CustomFAB(
        text: 'Done',
        background: Theme.of(context).colorScheme.primary,
        icon: Icons.done_rounded,
        func: () {
          bool validForm = formKey.currentState!.validate();
          if (validForm) {
            Navigator.of(context).pop();
          }
        },
        foreground: Theme.of(context).colorScheme.onPrimary,
        scrollController: scrollController,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Update Profile',
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          controller: scrollController,
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                displayPhotoField(),
                const SizedBox(
                  height: 10,
                ),
                fullNameField(),
                const SizedBox(
                  height: 10,
                ),
                genderField(),
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
                citizenshipPhotoField(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fab(),
    );
  }
}
