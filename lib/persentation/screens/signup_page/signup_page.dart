import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/gap_manager.dart';
import 'package:kydu/const/text_manager.dart';
import 'package:kydu/persentation/screens/signup_page/signup_controller.dart';
import 'package:kydu/persentation/screens/signup_page/widget/custom_hint_text.dart';
import 'package:kydu/persentation/screens/signup_page/widget/form_container/form_container_widget.dart';
import 'package:kydu/persentation/screens/signup_page/widget/navigate_back_buttom.dart';
import 'package:kydu/persentation/screens/signup_page/widget/signup_button.dart';
import 'widget/already_have_account.dart';

//This is the signup page in app where the user can singup in the in the application
class SignUpPage extends StatelessWidget {
  final SignUpController signUpController = SignUpController();
  final GlobalKey<FormState> _key = GlobalKey();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    //This is to have  disable the photo when the keyboard is oppened by the user
    final keyboardVisibility = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      appBar: AppBar(leading: const NavigateBackButton()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const DefaultTitle(
              color: kblack,
              title: "SignUp",
            ),
            kheight10,
            GetBuilder<SignUpController>(
              init: signUpController,
              builder: (_) => Form(
                key: _key,
                child: Column(
                  children: [
                    const CustomHintText(
                      hintText: 'Full Name',
                    ),
                    FormContainerWidget(
                      isPasswordField: false,
                      hintText: 'Enter your name',
                      labelText: 'User Name',
                      controller: signUpController.userNameController,
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "User Name is required";
                        }
                        if (!usernameRegex.hasMatch(value)) {
                          return "Invalid User Name format";
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                    ),
                    const CustomHintText(
                      hintText: 'Eamil',
                    ),
                    FormContainerWidget(
                      isPasswordField: false,
                      hintText: 'Enter your email',
                      labelText: 'Email',
                      controller: signUpController.emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        if (!emailRegex.hasMatch(value)) {
                          return "Invalid email format";
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                    ),
                    const CustomHintText(
                      hintText: 'Password',
                    ),
                    FormContainerWidget(
                      isPasswordField: true,
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      controller: signUpController.passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                    ),
                    kheight20,
                    SignUpButton(
                      signUpController: signUpController,
                      formKey: _key,
                      isSignIn: true,
                    ),
                  ],
                ),
              ),
            ),
            //This is the row widget to  display  if the user have account already
            const HaveAccount(),
          ],
        ),
      ),
    );
  }
}
