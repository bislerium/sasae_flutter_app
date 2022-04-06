import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomObscureTextField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final String labeltext;
  final String? Function(String?)? validators;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final Widget? prefixIcon;
  final Color? iconColor;

  const CustomObscureTextField({
    Key? key,
    this.textEditingController,
    required this.labeltext,
    required this.validators,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onSaved,
    this.onChanged,
    this.prefixIcon,
    this.iconColor,
  }) : super(key: key);

  @override
  State<CustomObscureTextField> createState() => _CustomObscureTextFieldState();
}

class _CustomObscureTextFieldState extends State<CustomObscureTextField> {
  bool _isObscure;

  _CustomObscureTextFieldState() : _isObscure = true;

  void _toggleObscure() => setState(() => _isObscure = !_isObscure);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'name_${widget.labeltext}',
      controller: widget.textEditingController,
      decoration: InputDecoration(
        labelText: widget.labeltext,
        iconColor: widget.iconColor ?? Theme.of(context).colorScheme.secondary,
        prefixIcon: widget.prefixIcon,
        suffixIcon: GestureDetector(
          onTap: _toggleObscure,
          child: _isObscure
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
        ),
      ),
      validator: widget.validators,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _isObscure,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
    );
  }
}
