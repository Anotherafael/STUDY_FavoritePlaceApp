import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTextFieldWidget extends ConsumerWidget {
  const CustomTextFieldWidget({
    super.key,
    required this.labelText,
    this.hintText,
    this.keyboardType,
    required this.onSaved,
  });

  final String labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final Function(String?)? onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText is required';
        }
        if (value.length < 3 || value.length > 50) {
          return '$labelText must be between 3 and 50 characters long';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
