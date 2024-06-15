import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/persentation/screens/login_page/login_page.dart';
import 'package:kydu/persentation/screens/login_page/login_page_controller.dart';

//This is the dialog box for the log of the out of the user from the application
class LogoutDialog {
  static void showConfirmationDialog(BuildContext context) {
    final LogInController logInController = Get.put(LogInController());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Clear the authentication token
                await logInController.logout();

                // Navigate to the login page and clear the stack
                Get.offAll(() => LogInPage());
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
