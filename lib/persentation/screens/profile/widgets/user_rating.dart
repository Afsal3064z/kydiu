import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';

class UserRating extends StatelessWidget {
  final String score;
  final IconData icon1;
  final IconData icon2;
  final IconData icon3;
  final IconData icon4;
  final IconData icon5;
  const UserRating({
    super.key,
    required this.score,
    required this.icon1,
    required this.icon2,
    required this.icon3,
    required this.icon4,
    required this.icon5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          score,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 10,
        ),
        Icon(
          icon1,
          color: mainColor,
          size: 30,
        ),
        Icon(
          icon2,
          color: mainColor,
          size: 30,
        ),
        Icon(
          icon3,
          color: mainColor,
          size: 30,
        ),
        Icon(
          icon4,
          color: mainColor,
          size: 30,
        ),
        Icon(
          icon5,
          color: mainColor,
          size: 30,
        )
      ],
    );
  }
}
