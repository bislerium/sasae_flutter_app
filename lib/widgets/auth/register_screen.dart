import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:image_picker/image_picker.dart';
import '../misc/custom_image_picker.dart';
import '../misc/date_picker.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;

  final formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;
      _image = File(image.path);
    } on PlatformException catch (e) {
      print(e);
      print('failed to pick');
    }
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

  void showPickImageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getPostModalItem(_, Icons.file_upload, 'Pick image from gallery',
                  () {
                pickImage(ImageSource.gallery);
                Navigator.pop(context);
              }),
              getPostModalItem(_, Icons.camera_alt, 'Click and pick image', () {
                pickImage(ImageSource.camera);
                Navigator.pop(context);
              }),
            ],
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
    );
  }

  List<String> genderList = [
    'Male',
    'Female',
    'LGBTQ+',
  ];

  String? dropdownValue;

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
        items: genderList
            .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
      );

  List<Step> getSteps() => [
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 0,
          title: const Text('Personal Info'),
          content: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Full Name'),
                  icon: Icon(Icons.person),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _dropDownGender(),
              const SizedBox(
                height: 10,
              ),
              const DatePickerField(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Step(
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 1,
          title: const Text('Address'),
          content: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Country'),
                  icon: Icon(Icons.flag_rounded),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Province'),
                  icon: Icon(Icons.local_parking_rounded),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('City/Locality'),
                  icon: Icon(Icons.location_city_rounded),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Street name/House number'),
                  icon: Icon(Icons.near_me),
                ),
                keyboardType: TextInputType.streetAddress,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Step(
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 2,
          title: const Text('Contact'),
          subtitle: const Text(
              'Email is not only used to contact\n but also to secure your account.'),
          content: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    label: Text('Phone'),
                    icon: Icon(Icons.phone_android_rounded),
                    hintText: 'E.g. +9779800740959'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    label: Text('Email'),
                    icon: Icon(Icons.email_rounded),
                    hintText: 'Only unique email is accepted'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Step(
          state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 3,
          title: const Text('Account'),
          content: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Username'),
                  icon: Icon(Icons.account_circle_rounded),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Password'),
                  icon: Icon(Icons.password_rounded),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const CustomImagePicker(
                title: 'Profile Picture',
                icon: Icons.photo_camera_front_rounded,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Step(
          state: _currentStep > 4 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 4,
          title: const Text('Verify'),
          subtitle: const Text(
              'This is optional.\n Profile verification might take some time!'),
          content: Column(
            children: const [
              CustomImagePicker(
                title: 'Citizenship Photo',
                icon: Icons.folder_shared_rounded,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    var isLastStep = _currentStep == getSteps().length - 1;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Register'),
      body: Stepper(
        type: StepperType.vertical,
        steps: getSteps(),
        currentStep: _currentStep,
        onStepContinue: () {
          if (isLastStep) {
          } else {
            setState(() {
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
