import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/home_page/bottom_nav/home_page.dart';
import 'package:kydu/persentation/screens/intro_pages/intro_page_1/intro_page_1.dart';
import 'package:kydu/persentation/screens/login_page/login_check/check_loggedin.dart';
import 'package:kydu/persentation/screens/login_page/login_page_controller.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBaZBOpE-m9-pmFYzrwEtvR84w7AAadZ-k",
      authDomain: "kyduchat.firebaseapp.com",
      databaseURL:
          "https://kyduchat-default-rtdb.asia-southeast1.firebasedatabase.app",
      projectId: "kyduchat",
      storageBucket: "kyduchat.appspot.com",
      messagingSenderId: "522331265700",
      appId: "1:522331265700:web:c7a3d5f35247ef736ea431",
      measurementId: "G-XED5N2T4S2",
    ),
  );

  // Initialize awesome_notifications
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
  );

  // Check if notification permission is allowed
  bool isNotificationAllowed =
      await AwesomeNotifications().isNotificationAllowed();

  if (!isNotificationAllowed) {
    // Permission not granted, request it
    await _requestNotificationPermission();
  }

  // Initialize Firebase Messaging
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Handle the incoming FCM message and show a notification
    showNotification(message.data);
    log("Notification was sent: ");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle the message when the app is opened from a background notification
    log("App opened from background notification: ${message.data}");
  });

  // Use GetX for dependency injection
  Get.put(LogInController());

  runApp(const MyApp());
}

void showNotification(Map<String, dynamic> messageData) {
  // Use awesome_notifications package or any other package to show the notification.
  // Example using awesome_notifications:
  log("+++++++++++++++++++++++++++");
  log('Received FCM Message: $messageData');

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'basic_channel',
      title: messageData['title'] ?? 'Default Title',
      body: messageData['body'] ?? 'Default Body',
      bigPicture: messageData['image'] ?? '',
    ),
  );
}

Future<void> _requestNotificationPermission() async {
  // Request notification permission
  PermissionStatus status = await Permission.notification.request();

  if (status.isGranted) {
    log('Notification permission granted');
  } else {
    log('Notification permission denied');
    // Handle the case where notification permission is denied
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kydu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const RootPage()),
        GetPage(name: '/homepage', page: () => HomePage()),
        GetPage(name: '/intro1', page: () => const IntroPage1()),
      ],
    );
  }
}
