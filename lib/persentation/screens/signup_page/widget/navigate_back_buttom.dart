import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/intro_pages/intro_page_1/intro_page_1.dart';

class NavigateBackButton extends StatelessWidget {
  const NavigateBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
            border: Border.all(
              color: kblack,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(50)),
        child: IconButton(
          onPressed: () {
            Get.to(const IntroPage1());
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
          ),
        ),
      ),
    );
  }
}
