import 'package:flutter/material.dart';

import 'Colors_Utils.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField({super.key, required this.controller, required this.hintText, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppColors.grey), borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          fillColor: AppColors.white,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black54)),
    );
  }
}
