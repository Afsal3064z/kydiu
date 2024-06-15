import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//These are the constant  colors used in the app
const mainColor = Color.fromRGBO(242, 181, 64, 1);
const mainDarkColor = Color.fromRGBO(121, 135, 255, 1);
const bgColor = Color.fromRGBO(242, 181, 64, 1);
const secodaryColor = Color.fromARGB(255, 39, 47, 1);
const kwhite = Colors.white;
const kgrey = Colors.grey;
const kblack = Colors.black;
///////////////////////////////////////
//This is the rejex expression for the form valiaation
//This is the rejex expression for the user name..
RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');

//This is the rejex expression for the email...
RegExp emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9_.-]+\.[a-zA-Z]{2,}$');

//This is the rejex expression for the password...

///////////////////////////////////////////////
// This is the api key for the google maps
const String apiKey = "AIzaSyAb41YFFtdqSegUvVWTYa13T1Ul7hJ3WSI";
// storage_utils.dart

Future<bool> checkFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  if (isFirstTime) {
    await prefs.setBool('isFirstTime', false);
  }
  return isFirstTime;
}
