import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import '../misc/custom_image_picker.dart';
import '../misc/custom_widgets.dart';
import '../misc/date_picker.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;

  final personalInfoFormKey = GlobalKey<FormState>();
  final addressFormKey = GlobalKey<FormState>();
  final contactFormKey = GlobalKey<FormState>();
  final accountFormKey = GlobalKey<FormState>();

  var userNameField = TextEditingController();
  var passwordField = TextEditingController();
  var fullNameField = TextEditingController();
  var countryField = TextEditingController();
  var provinceField = TextEditingController();
  var cityLocalityField = TextEditingController();
  var stAddressHouseNumField = TextEditingController();
  var phoneField = TextEditingController();
  var emailField = TextEditingController();
  String? dropdownValue;
  DateTime? pickedDate;
  File? profilePicture;
  File? citizenshipPhoto;

  @override
  void dispose() {
    userNameField.dispose();
    passwordField.dispose();
    fullNameField.dispose();
    countryField.dispose();
    provinceField.dispose();
    cityLocalityField.dispose();
    stAddressHouseNumField.dispose();
    phoneField.dispose();
    emailField.dispose();
    super.dispose();
  }

  ListTile getPostModalItem(
      BuildContext ctx, IconData icon, String title, VoidCallback func) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: Theme.of(ctx).primaryColor,
      ),
      title: Text(title),
      onTap: func,
    );
  }

  List<String> genderList = [
    'Male',
    'Female',
    'LGBTQ+',
  ];

  Widget _dropDownGender() => DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          icon: Icon(Icons.transgender),
          labelText: 'Gender',
        ),
        onChanged: (newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        validator: (value) {
          return checkValue(
            value: value,
            checkEmptyOnly: true,
          );
        },
        items: genderList
            .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
      );

  final _stepErrors = [
    false,
    false,
    false,
    false,
  ];

  List<Step> getSteps() => [
        Step(
          state: _stepErrors[0]
              ? StepState.error
              : _currentStep > 0
                  ? StepState.complete
                  : StepState.indexed,
          isActive: _currentStep >= 0,
          title: const Text('Personal Info'),
          content: Form(
            key: personalInfoFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: fullNameField,
                  decoration: const InputDecoration(
                    label: Text('Full name'),
                    icon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    return checkValue(
                      value: value,
                      checkEmptyOnly: true,
                    );
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 10,
                ),
                _dropDownGender(),
                const SizedBox(
                  height: 10,
                ),
                DatePickerField(
                  setDateHandler: (value) => pickedDate = value,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _stepErrors[1]
              ? StepState.error
              : _currentStep > 1
                  ? StepState.complete
                  : StepState.indexed,
          isActive: _currentStep >= 1,
          title: const Text('Address'),
          content: Form(
            key: addressFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: countryField,
                  decoration: const InputDecoration(
                    label: Text('Country'),
                    icon: Icon(Icons.flag_rounded),
                  ),
                  validator: (value) {
                    return checkValue(
                      value: value,
                      checkEmptyOnly: true,
                    );
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: provinceField,
                  decoration: const InputDecoration(
                    label: Text('Province'),
                    icon: Icon(Icons.local_parking_rounded),
                  ),
                  validator: (value) {
                    return checkValue(
                      value: value,
                      checkEmptyOnly: true,
                    );
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: cityLocalityField,
                  decoration: const InputDecoration(
                    label: Text('City/Locality'),
                    icon: Icon(Icons.location_city_rounded),
                  ),
                  validator: (value) {
                    return checkValue(
                      value: value,
                      checkEmptyOnly: true,
                    );
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: stAddressHouseNumField,
                  decoration: const InputDecoration(
                    label: Text('Street name/House number'),
                    icon: Icon(Icons.near_me),
                  ),
                  validator: (value) {
                    return checkValue(
                      value: value,
                      checkEmptyOnly: true,
                    );
                  },
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.streetAddress,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _stepErrors[2]
              ? StepState.error
              : _currentStep > 2
                  ? StepState.complete
                  : StepState.indexed,
          isActive: _currentStep >= 2,
          title: const Text('Contact'),
          subtitle: const Text(
              'Email is not only used to contact\n but also to secure your account.'),
          content: Form(
            key: contactFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: phoneField,
                  decoration: const InputDecoration(
                    label: Text('Phone'),
                    icon: Icon(Icons.phone_android_rounded),
                    hintText: 'E.g. 9800740959',
                  ),
                  validator: (value) {
                    return checkValue(
                      value: value,
                      pattern: r'(^[9][678][0-9]{8}$)',
                      patternMessage: 'Invalid phone number!',
                    );
                  },
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailField,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                    icon: Icon(Icons.email_rounded),
                    hintText: 'Only unique email is accepted',
                  ),
                  validator: (value) {
                    return checkValue(
                      value: value,
                      pattern:
                          r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)',
                      patternMessage: 'Invalid email!',
                    );
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _stepErrors[3]
              ? StepState.error
              : _currentStep > 3
                  ? StepState.complete
                  : StepState.indexed,
          isActive: _currentStep >= 3,
          title: const Text('Account'),
          subtitle: const Text('Profile picture is optional.'),
          content: Form(
            key: accountFormKey,
            child: Column(
              children: [
                CustomImagePicker(
                  title: 'Profile picture',
                  icon: Icons.photo_camera_front_rounded,
                  setImageFileHandler: (image) => profilePicture = image,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: userNameField,
                  decoration: const InputDecoration(
                    label: Text('Username'),
                    icon: Icon(Icons.account_circle_rounded),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required Field!';
                    } else if (value.contains(' ')) {
                      return 'Username must be spaceless!';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwordField,
                  decoration: const InputDecoration(
                    label: Text('Password'),
                    icon: Icon(Icons.password_rounded),
                  ),
                  validator: (value) {
                    return checkValue(
                      value: value,
                      checkEmptyOnly: true,
                    );
                  },
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Confirm password'),
                    icon: Icon(Icons.password_rounded),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required field!';
                    } else if (passwordField.text != value) {
                      return 'Passwords did not match!';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _currentStep > 4 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 4,
          title: const Text('Verify'),
          subtitle: const Text(
              'This is optional.\n Profile verification might take some time!'),
          content: Column(
            children: [
              CustomImagePicker(
                title: 'Citizenship Photo',
                icon: Icons.folder_shared_rounded,
                setImageFileHandler: (image) => citizenshipPhoto = image,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ];

  List<bool Function()> validity() => [
        () => personalInfoFormKey.currentState!.validate(),
        () => addressFormKey.currentState!.validate(),
        () => contactFormKey.currentState!.validate(),
        () => accountFormKey.currentState!.validate(),
      ];

  @override
  Widget build(BuildContext context) {
    var isLastStep = _currentStep == getSteps().length - 1;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Register',
      ),
      body: Stepper(
        type: StepperType.vertical,
        steps: getSteps(),
        currentStep: _currentStep,
        onStepContinue: () {
          if (isLastStep) {
            if (_stepErrors.contains(true)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Please fill required fields!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Successfully Registered!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                ),
              );
            }
          } else {
            var valid = validity()[_currentStep]();
            setState(() {
              _stepErrors[_currentStep] = !valid;
              _currentStep++;
            });
          }
        },
        onStepCancel: () {
          if (_currentStep == 0) {
            null;
          } else {
            setState(() {
              _currentStep--;
            });
          }
        },
        onStepTapped: (value) {
          setState(() {
            if (!isLastStep) {
              for (int i = 0; i < value; i++) {
                _stepErrors[i] = !validity()[i]();
              }
            }
            _currentStep = value;
          });
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      isLastStep ? Icons.how_to_reg : Icons.navigate_next,
                    ),
                    label: Text(
                      isLastStep ? 'Register' : 'Next',
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    onPressed: details.onStepContinue,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextButton(
                    child: const Text('Back'),
                    onPressed: details.onStepCancel,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
