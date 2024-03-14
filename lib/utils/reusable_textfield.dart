import 'package:flutter/material.dart';

class ReusableTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hinttxt;
  final String keyboardType;

  const ReusableTextField(
      {super.key,
      required this.controller,
      required this.hinttxt,
      required this.keyboardType});

  @override
  State<ReusableTextField> createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: widget.controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required Field';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        hintText: widget.hinttxt,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
