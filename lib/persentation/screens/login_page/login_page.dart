import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/gap_manager.dart';
import 'package:kydu/const/text_manager.dart';
import 'package:kydu/persentation/screens/login_page/login_page_controller.dart';
import 'package:kydu/persentation/screens/login_page/widget/dont_have_account.dart';
import 'package:kydu/persentation/screens/login_page/widget/login_button.dart';
import 'package:kydu/persentation/screens/signup_page/widget/custom_hint_text.dart';
import 'package:kydu/persentation/screens/signup_page/widget/form_container/form_container_widget.dart';
import 'package:kydu/persentation/screens/signup_page/widget/navigate_back_buttom.dart';

//This is the login page in the application where the user can login to the application
class LogInPage extends StatelessWidget {
  final LogInController logInController = Get.put(LogInController());
  final GlobalKey<FormState> formKey = GlobalKey();

  LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final keyboardVisibility = MediaQuery.of(context).viewInsets.bottom > 0;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const NavigateBackButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!keyboardVisibility)
                  const Column(
                    children: [
                      MainTitle(
                        title: "Kydu",
                      ),
                      kheight80,
                    ],
                  ),
                kheight20,
                const DefaultTitle(
                  color: kblack,
                  title: "SignIn",
                ),
                kheight20,
                //This is the form container for the email
                const CustomHintText(
                  hintText: 'Eamil',
                ),
                FormContainerWidget(
                  isPasswordField: false,
                  hintText: 'Email',
                  labelText: 'Email',
                  controller: logInController.emailController,
                  inputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!emailRegex.hasMatch(value)) {
                      return "Invalid Email format";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                kheight20,
                const CustomHintText(
                  hintText: 'Password',
                ),
                //This is the form container for the password
                FormContainerWidget(
                  isPasswordField: true,
                  hintText: 'Password',
                  labelText: 'Password',
                  controller: logInController.passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => logInController.login(),
                ),
                kheight20,
                LogInButton(
                  formKey: formKey,
                  logInController: logInController,
                ),
                //This is to display if the user doesnt have acoount...
                const DontHaveAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
