import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';

//This is the container for the form filed
class FormContainerController extends GetxController {
  TextEditingController textController = TextEditingController();
  RxBool obscureText = true.obs;
  Rx<Color> borderColor = mainColor.obs;
  RxString errorMessage = ''.obs;
  //This is the methode to toggle  the obscure text in the password field
  void toggleObscureText() {
    obscureText.toggle();
  }

//This is the methode to toggle the border color in the application
  void setBorderColor(bool isValid) {
    borderColor.value = isValid ? mainColor : Colors.red;
  }

//This is the methode to toggle the error message in the application
  void setErrorMessage(String message) {
    errorMessage.value = message;
  }
}
