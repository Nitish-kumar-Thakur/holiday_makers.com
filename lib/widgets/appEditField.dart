import 'package:flutter/material.dart';

class AppEditField extends StatelessWidget {
  final String labeltext;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const AppEditField({
    super.key,
    required this.labeltext, 
    required this.controller,
    required this.focusNode,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4), // Shadow color
            blurRadius: 8, // Controls how soft the shadow is
            offset: const Offset(0, 4), // X and Y offset;
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: validator, // Validation logic
        onChanged: onChanged, // Callback for real-time input tracking
        decoration: InputDecoration(
          hintText: labeltext,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 15),
          labelStyle: const TextStyle(color: Colors.black54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}
