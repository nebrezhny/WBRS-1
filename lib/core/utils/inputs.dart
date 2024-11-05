import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget _buildTextField({
  required TextEditingController controller,
  required String labelText,
  required bool obscureText,
}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      labelText: labelText,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
    ),
    obscureText: obscureText,
  );
}
