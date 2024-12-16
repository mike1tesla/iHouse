import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;

  const BasicAppButton({super.key, required this.onPressed, required this.title, this.height = 80});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height!),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xffF6F6F6),
          fontFamily: "Satoshi",
          fontSize: 14
        ),
      ),
    );
  }
}
