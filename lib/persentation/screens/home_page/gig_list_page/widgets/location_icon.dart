import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';

class LocationIcon extends StatelessWidget {
  final double? size;
  const LocationIcon({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.location_on,
      color: mainColor,
      size: size,
    );
  }
}
