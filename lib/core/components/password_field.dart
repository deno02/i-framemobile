import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const PasswordField({required this.controller, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      style: GoogleFonts.roboto(
        textStyle: const TextStyle(color: Colors.black),
      ),
    );
  }
}
