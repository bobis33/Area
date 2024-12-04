import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget textField({
  required TextEditingController controller,
  required String label,
  String? errorText,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      errorText: errorText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    obscureText: obscureText,
    keyboardType: keyboardType,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'\s')),
    ],
  );
}
