import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/gap_manager.dart';
import 'package:kydu/persentation/screens/profile/logout_dialog_box.dart';
import 'package:kydu/persentation/screens/profile/profile_controller/profile_controller.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final UserProfileController userProfileController = UserProfileController(
    'http://your_api_base_url',
  );
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      // Replace 'your_auth_token' with the actual authentication token
      userProfile =
          await userProfileController.fetchUserProfile('your_auth_token');
    } catch (error) {
      // Handle error
      log('Error fetching user profile: $error');
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return userProfile != null
        ? _buildUserProfile(userProfile!)
        : _buildLoading();
  }

  Widget _buildUserProfile(Map<String, dynamic> userProfile) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              child: Icon(
                Icons.person,
                color: mainColor,
                size: 50,
              ),
            ),
            kheight20,
            Text(
              'User Name: ${userProfile['name']}',
              style: const TextStyle(
                color: mainColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            kheight20,
            Text(
              'Email: ${userProfile['email']}',
              style: const TextStyle(
                color: mainColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            kheight20,
            Text(
              'Location: ${userProfile['location']}',
              style: const TextStyle(
                color: mainColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                LogoutDialog.showConfirmationDialog(context);
              },
              icon: const Icon(
                Icons.logout,
                color: mainColor,
                size: 30,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
