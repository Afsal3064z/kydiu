import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/login_page/login_page.dart';
import 'package:kydu/persentation/screens/signup_page/signup_controller.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
    required this.signUpController,
    required this.formKey,
    required bool isSignIn,
  });

  final SignUpController signUpController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          // Set loading state
          signUpController.setLoading(true);
          //call the api after validation..
          bool success = await signUpController.signUp();

          // Reset loading state
          signUpController.setLoading(false);

          if (success) {
            Get.snackbar(
              'Sign Up Successful',
              'You have successfully signed up!',
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(20.0),
            );
            Get.to(() => LogInPage());
            log("Signup is successful");
          } else {
            Get.snackbar(
              'Sign Up Failed',
              'Error: ${signUpController.signupError.value}',
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(20.0),
              borderRadius: 8.0,
              colorText: Colors.white,
              backgroundColor: Colors.red,
              onTap: (snackController) {
                Get.to(LogInPage());
              },
              mainButton: TextButton(
                onPressed: () {
                  Get.to(LogInPage());
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
        } else {
          Get.snackbar(
            'Sign Up Failed',
            'Error: ${_getErrorMessage()}',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(20.0),
            borderRadius: 8.0,
            colorText: Colors.white,
            backgroundColor: Colors.red,
            mainButton: TextButton(
              onPressed: () {
                Get.to(LogInPage());
              },
              child: const Text(
                "Login",
                style: TextStyle(color: kwhite),
              ),
            ),
          );
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
      // Conditional child based on loading state
      child: signUpController.isLoading.value
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(mainColor))
          : const Text(
              'Create Account',
              style: TextStyle(fontSize: 16, color: kwhite),
            ),
    );
  }

  String _getErrorMessage() {
    if (signUpController.signupError.value.isEmpty) {
      return 'Please fill in all fields';
    } else {
      return 'Error: ${signUpController.signupError.value}';
    }
  }
}
