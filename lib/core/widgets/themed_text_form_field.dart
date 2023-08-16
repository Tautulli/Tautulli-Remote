import 'package:flutter/material.dart';

class ThemedTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final Widget? suffixIcon;
  final int? errorMaxLines;
  final Function()? onTap;
  final String? Function(String?)? validator;

  const ThemedTextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.suffixIcon,
    this.errorMaxLines,
    this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autocorrect: false,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        labelText: labelText,
        hintText: hintText,
        errorMaxLines: errorMaxLines,
        isDense: true,
        iconColor: Theme.of(context).colorScheme.onSurface,
        suffixIcon: suffixIcon,
      ),
      onTap: onTap,
      validator: validator,
    );
  }
}
