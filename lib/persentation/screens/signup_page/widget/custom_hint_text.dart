import 'package:flutter/material.dart';

class CustomHintText extends StatelessWidget {
  final String hintText;
  const CustomHintText({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            hintText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )),
    );
  }
}