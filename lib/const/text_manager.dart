import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';

//This will be the text manager of the app
//This is the default  text in  all pages
class MainTitle extends StatelessWidget {
  final String title;
  const MainTitle({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          color: mainColor, fontSize: 36, fontWeight: FontWeight.w900),
    );
  }
}

class DefaultTitle extends StatelessWidget {
  final String title;
  final Color color;
  final double? fontSize;

  // Use required for a non-nullable parameter
  const DefaultTitle({
    super.key,
    required this.title,
    required this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: color, fontSize: 20),
    );
  }
}

/////////////////////////////////////////////////////////////////
//This is the default sub text in  all pages
class SubTitle extends StatelessWidget {
  final Color color;
  final String subtitle;
  final double? fontSize;
  const SubTitle({
    super.key,
    required this.subtitle,
    required this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
      ),
      textAlign: TextAlign.center,
    );
  }
}

//////////////////////////////////////////////////
//This is the text  manager for the user name listing in the app ui
class UserName extends StatelessWidget {
  final String userName;
  const UserName({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      userName,
      style: const TextStyle(
          color: mainColor, fontWeight: FontWeight.bold, fontSize: 25),
    );
  }
}

class CustomTitle extends StatelessWidget {
  final String title;
  const CustomTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          color: mainColor, fontWeight: FontWeight.bold, fontSize: 25),
    );
  }
}

class OfferText extends StatelessWidget {
  const OfferText({
    super.key,
    required this.offer,
  });

  final String? offer;

  @override
  Widget build(BuildContext context) {
    return Text(
      "\$$offer",
      style: const TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
    );
  }
}
