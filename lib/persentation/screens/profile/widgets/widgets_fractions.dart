
import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';

class Linner extends StatelessWidget {
  const Linner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Divider(
        color: mainColor,
        thickness: 2.0,
        height: 20.0,
      ),
    );
  }
}
