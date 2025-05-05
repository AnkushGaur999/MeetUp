import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  final TextEditingController? controller;
  final int? maxLength;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? prefixText;

  const AuthFormField({
    super.key,
    this.controller,
    this.maxLength,
    this.keyboardType,
    this.hint,
    this.obscureText = false,
    this.prefixText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(),
          suffixIcon: suffixIcon,
          prefixText: prefixText,
          counterText: ""
        ),
        validator: (value){
          if(value!.isEmpty){
            return "Field required";
          }
          return null;
        },
      ),
    );
  }
}
