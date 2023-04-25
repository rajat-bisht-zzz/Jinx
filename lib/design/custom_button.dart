import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function()? onPressed;
  final Color textColor;
  final Color buttonColor;

  CustomButton({required this.buttonText, required this.onPressed, required this.textColor, required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: (buttonText == "Login") ? 50 : 35,
        width: 150,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: textColor,
            width: 3
          ),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "monospace"
            ),
          ),
        ),
      ),
    );
  }
}
