import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width/ 1.2,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.white,
          ),
          labelStyle: const TextStyle(color: Colors.white),
          filled: false,
          hintText: labelText,
          hintStyle: const TextStyle(
            color: Colors.white
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.white, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.white, width: 3),
          ),
        ),
      ),
    );
  }
}
