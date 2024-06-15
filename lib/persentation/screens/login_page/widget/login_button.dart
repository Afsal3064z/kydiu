import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/home_page/bottom_nav/home_page.dart';
import 'package:kydu/persentation/screens/login_page/login_page_controller.dart';

//need to hide the key board and call the api
class LogInButton extends StatelessWidget {
  const LogInButton({
    super.key,
    required this.formKey,
    required this.logInController,
  });

  final GlobalKey<FormState> formKey;
  final LogInController logInController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Check if any of the form fields are empty
        if (_areFieldsEmpty()) {
          showGetSnackbar('Please fill in all fields');
          return;
        }

        // Attempt login
        bool loginSuccess = await logInController.login();

        if (loginSuccess) {
          // Navigate to home page if login is successful
          Get.offAll(() {
            Get.delete<LogInController>(); // Remove the LogInController
            return HomePage();
          });

          Get.snackbar('Login Successfull', " You successfully log In",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
              backgroundColor: mainColor,
              colorText: Colors.white,
              margin: const EdgeInsets.all(20));
        } else {
          // Handle login failure, show a message if needed
          // For example, you can show a GetX SnackBar
          showGetSnackbar('Invalid email or password');
        }
      },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(300, 50)),
        fixedSize: MaterialStateProperty.all(const Size(300, 50)),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            return states.contains(MaterialState.pressed)
                ? secodaryColor
                : secodaryColor;
          },
        ),
      ),
      child: logInController.isLoading.value
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(mainColor))
          : const Text(
              'SignIn',
              style: TextStyle(fontSize: 16, color: kwhite),
            ),
    );
  }

  // Helper method to show a GetX SnackBar
  void showGetSnackbar(String message) {
    Get.snackbar('Login Failed', message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20));
  }

  // Helper method to check if any of the form fields are empty
  bool _areFieldsEmpty() {
    return logInController.emailController.text.isEmpty ||
        logInController.passwordController.text.isEmpty;
  }
}
