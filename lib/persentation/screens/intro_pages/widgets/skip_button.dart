import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/signup_page/signup_page.dart';

//This is the skip button for the intro pages
class SkipButton extends StatelessWidget {
  const SkipButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 0, top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              onPressed: () {
                Get.offAll(() => SignUpPage());
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: kwhite,
                  fontSize: 20,
                ),
              ))
        ],
      ),
    );
  }
}
