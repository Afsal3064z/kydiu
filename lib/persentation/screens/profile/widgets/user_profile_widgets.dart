import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';

class ProflieSlide extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ProflieSlide({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: mainColor,
          size: 30,
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 20,
          ),
        )
      ],
    );
  }
}
