import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';

class ClockIcon extends StatelessWidget {
  final double? size;
  const ClockIcon({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.timer,
      color: mainColor,
      size: size,
    );
  }
}
