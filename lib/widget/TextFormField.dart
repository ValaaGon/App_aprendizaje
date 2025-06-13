import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final bool readOnly;
  final bool obscureText;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.readOnly = false,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF545979);

    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: borderColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
