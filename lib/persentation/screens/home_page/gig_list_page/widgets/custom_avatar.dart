import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';

class CustomAvatar extends StatelessWidget {
  final double? radius;
  final double? childSize;
  const CustomAvatar({
    super.key,
    this.radius,
    this.childSize,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: secodaryColor,
      radius: radius,
      child: Center(
          child: Icon(
        Icons.person,
        size: childSize,
        color: kwhite,
      )),
    );
  }
}
