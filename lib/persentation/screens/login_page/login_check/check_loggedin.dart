import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/persentation/screens/home_page/bottom_nav/home_page.dart';
import 'package:kydu/persentation/screens/intro_pages/intro_page_1/intro_page_1.dart';
import 'package:kydu/persentation/screens/login_page/login_page.dart';
import 'package:kydu/persentation/screens/login_page/login_page_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootPage extends StatelessWidget {
  const RootPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasSeenIntroPages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data!
              ? const CheckLoggedInPage()
              : const IntroPage1();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<bool> _hasSeenIntroPages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenIntroPages') ?? false;
  }
}

// check_loggedin.dart
class CheckLoggedInPage extends StatelessWidget {
  const CheckLoggedInPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final LogInController loginController = Get.find();
    return FutureBuilder<bool>(
      future: loginController.checkLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data!) {
            return HomePage();
          } else {
            return LogInPage();
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
