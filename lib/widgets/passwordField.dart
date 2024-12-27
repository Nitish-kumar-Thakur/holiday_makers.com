import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const PasswordField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.validator,
    this.onChanged,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

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
            offset: Offset(0, 4), // X and Y offset
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        validator: widget.validator, // Validation logic
        onChanged: widget.validator,
        obscureText: _obscureText, // Toggle visibility
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 15),
          labelStyle: const TextStyle(color: Colors.black54),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility
               : Icons.visibility,
               color: _obscureText ? Colors.black54 : Color(0xFF3498DB), size: 30,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText; // Toggle obscureText
              });
            },
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}
