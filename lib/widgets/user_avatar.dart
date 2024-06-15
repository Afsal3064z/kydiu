import 'package:flutter/material.dart';

//This will be the avartar of the user were we can see the profile of the user
class UserAvatar extends StatelessWidget {
  final double radius;
  const UserAvatar({
    super.key,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
    );
  }
}
