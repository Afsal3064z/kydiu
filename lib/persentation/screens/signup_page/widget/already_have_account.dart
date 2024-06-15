import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/text_manager.dart';
import 'package:kydu/persentation/screens/login_page/login_page.dart';

class HaveAccount extends StatelessWidget {
  const HaveAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SubTitle(
          subtitle: "already have an account",
          color: mainColor,
        ),
        TextButton(
          onPressed: () {
            Get.off(() => LogInPage());
          },
          child: const Text("LogIn"),
        )
      ],
    );
  }
}
