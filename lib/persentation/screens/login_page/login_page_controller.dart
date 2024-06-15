import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kydu/const/api_provider/api_provider.dart';
import 'package:kydu/persentation/screens/home_page/bottom_nav/home_page.dart';
import 'package:kydu/persentation/screens/login_page/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

//This is the controller fro the login process in the application..
class LogInController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var emailErrorText = RxString('');
  var passwordErrorText = RxString('');
  RxString authToken = ''.obs;
  RxBool isLoading = false.obs;
  String? deviceToken;

  @override
  void onInit() {
    super.onInit();
    // Initialize device token when the controller is created
    getDeviceId();
  }

  // Method to attempt login
  Future<bool> login() async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
          'fcmToken': deviceToken
        }),
      );

      if (response.statusCode == 200) {
        // Successful login
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        authToken.value = responseData['token'];

        // Save the token to shared preferences for persistent login
        await saveTokenToSharedPreferences(authToken.value);
        log("authToken: ${authToken.value}");

        // Save a flag indicating that the user has seen intro pages
        await saveIntroFlagToSharedPreferences(true);

        return true;
      } else {
        return false; // Return false for login failure
      }
    } catch (e) {
      return false; // Return false for login failure
    } finally {
      isLoading.value = false;
    }
  }

  // Method to handle login
  Future<void> handleLogin() async {
    final loginSuccess = await login();

    if (loginSuccess) {
      // If login is successful, fetch the profile
      await fetchUserProfile();

      // Check if the user is logged in and navigate accordingly
      await checkLoggedIn();
    }
  }

  // Method to fetch user profile
  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      // Retrieve the stored token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedToken = prefs.getString('authToken');

      if (storedToken != null) {
        // Use the stored token to fetch user profile
        final ApiProvider apiProvider = ApiProvider('http://10.0.2.2:3000/api');
        final response = await apiProvider.getProfile(storedToken);

        if (response.statusCode == 200) {
          // Successful response, parse and return user details
          final userProfile = jsonDecode(response.body);
          log(response.body);
          return userProfile;
        } else {
          // Handle error
          log("Error: ${response.body}");
          return {}; // Return an empty map or handle the error case appropriately
        }
      } else {
        // Handle case where the token is null
        log("Error: AuthToken is null");
        return {}; // Return an empty map or handle the error case appropriately
      }
    } catch (error) {
      // Handle other errors
      log("Error: $error");
      return {}; // Return an empty map or handle the error case appropriately
    }
  }

  // Method to save the authentication token to shared preferences
  Future<void> saveTokenToSharedPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  // Method to save the flag indicating that the user has seen intro pages
  Future<void> saveIntroFlagToSharedPreferences(bool hasSeenIntro) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntroPages', hasSeenIntro);
  }

  // Method to check if the user is already logged in
  Future<bool> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('authToken');
    bool isLoggedIn = storedToken != null;

    if (!isLoggedIn) {
      // The user is not logged in, navigate to the login page
      Get.offAll(
          () => LogInPage()); // Replace LogInPage with your login page widget
    } else {
      // The user is logged in, navigate to the home page
      Get.offAll(
          () => HomePage()); // Replace HomePage with your home page widget
    }

    return isLoggedIn;
  }

  // This is the method to get the device token
  Future<void> getDeviceId() async {
    deviceToken = await FirebaseMessaging.instance.getToken();
    log("This is the device token of this device: $deviceToken");

    // Save the device token in SharedPreferences
    saveDeviceTokenToSharedPreferences(deviceToken);
  }

  // Method to save the device token in SharedPreferences
  Future<void> saveDeviceTokenToSharedPreferences(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('deviceToken', token ?? '');
  }

  // Method to log out
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');

    // Navigate to the login page and clear the stack
    Get.offAll(
        () => LogInPage()); // Replace LogInPage with your login page widget
  }
}
