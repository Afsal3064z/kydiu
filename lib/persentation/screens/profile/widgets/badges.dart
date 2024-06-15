import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';

class Badges extends StatelessWidget {
  final String title;
  final IconData icon;
  const Badges({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(mainColor),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: kwhite,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: const TextStyle(color: kwhite, fontSize: 20),
            )
          ],
        ));
  }
}
