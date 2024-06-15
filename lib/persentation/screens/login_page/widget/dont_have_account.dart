import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/text_manager.dart';
import 'package:kydu/persentation/screens/signup_page/signup_page.dart';

class DontHaveAccount extends StatelessWidget {
  const DontHaveAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SubTitle(
          subtitle: "Don't have an account ?",
          color: mainColor,
        ),
        TextButton(
          onPressed: () {
            Get.offAll(() => SignUpPage());
          },
          child: const Text("SignUp"),
        ),
      ],
    );
  }
}
