import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';

class PhotoPlaceHolder extends StatelessWidget {
  const PhotoPlaceHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: mainColor,
          width: 2.0, // Set the border width
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo,
            color: kgrey,
          ),
          Text(
            'No images added yet.',
            style: TextStyle(
              fontSize: 18,
              color: kgrey,
            ),
          ),
        ],
      ),
    );
  }
}
