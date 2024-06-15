import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kydu/const/contants.dart';
import 'package:shared_preferences/shared_preferences.dart';

//This is the controller for the  singup process in the application
class SignUpController extends GetxController {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  RxString emailErrorText = ''.obs;
  RxString passwordErrorText = ''.obs;
  Rx<Color> userNameBorderColor = mainColor.obs;
  Rx<Color> emailBorderColor = mainColor.obs;
  Rx<Color> passwordBorderColor = mainColor.obs;
  RxString authToken = ''.obs;
  String? deviceToken;
  RxString signupError = ''.obs;
  RxBool isLoading = false.obs; // Loading state

  @override
  void onInit() {
    super.onInit();
    // Load device token from SharedPreferences when the controller is initialized
    loadDeviceToken();
  }

  // Load device token from SharedPreferences
  Future<void> loadDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceToken = prefs.getString('deviceToken');
  }

  // Save device token to SharedPreferences
  Future<void> saveDeviceToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceToken', token);
  }

  //This is the methode to signup into the application
  Future<bool> signUp() async {
    try {
      // Set loading state
      setLoading(true);

      // Get device token if it's not already loaded
      if (deviceToken == null) {
        deviceToken = await getDeviceId();
        // Save the device token in SharedPreferences
        if (deviceToken != null) {
          saveDeviceToken(deviceToken!);
        }
      }

      final response = await http
          .post(
            Uri.parse('http://10.0.2.2:3000/api/signup'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': userNameController.text,
              'email': emailController.text,
              'password': passwordController.text,
              'fcmToken': deviceToken,
            }),
          ) //This is for the time out
          .timeout(const Duration(seconds: 1));
      if (response.statusCode == 201) {
        log('Signup successful');
        return true;
      } else if (response.statusCode == 400) {
        signupError.value = 'Email is already in use.';
        log('Signup failed: Email is already in use');
        return false;
      } else {
        signupError.value =
            'An unexpected error occurred during signup. Please try again later.';
        log('Signup failed with status code: ${response.statusCode}, Response body: ${response.body}');
        return false;
      }
    } on TimeoutException catch (_) {
      signupError.value = 'Server not reachable. Please check your server.';
      log('Timeout: Server not reachable');
      return false;
    } on SocketException catch (e) {
      signupError.value =
          'Network error. Please check your internet connection.';
      log('Network error during signup: $e');
      return false;
    } catch (e) {
      signupError.value = 'An error occurred during signup. Please try again.';
      log('Error during signup: $e');
      return false;
    } finally {
      // Reset loading state
      setLoading(false);
    }
  }

//This is the methode to get the device token
  Future<String?> getDeviceId() async {
    String? token = await FirebaseMessaging.instance.getToken();
    log("This is the device token of this device: $token");
    return token;
  }

//This is to know is it loading
  void setLoading(bool value) {
    isLoading.value = value;
  }
}
