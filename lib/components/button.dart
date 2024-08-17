import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  Color? backgroundColor;
  Color? textColor;
  final void Function() onPressed;

  CustomButton(
      {super.key,
      required this.label,
      this.backgroundColor,
      this.textColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.blueGrey),
        onPressed: onPressed,
        child: Text(label, style: TextStyle(color: textColor ?? Colors.white)));
  }
}
