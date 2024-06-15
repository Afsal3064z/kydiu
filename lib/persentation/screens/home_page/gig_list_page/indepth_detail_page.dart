import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/text_manager.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/widgets/clock_icon.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/widgets/custom_avatar.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/widgets/gig_image_list.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/widgets/location_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndepthDetailPage extends StatelessWidget {
  final String? category;
  final String? title;
  final String? description;
  final String? createdBy;
  final String? time;
  final String? locaiton;
  final List<String>? photos;
  final String? offer;
  final String? id;
  final String? userId; //This is the message reciver id...

  const IndepthDetailPage({
    super.key,
    this.category,
    this.title,
    this.description,
    this.createdBy,
    this.time,
    this.locaiton,
    this.photos,
    this.offer,
    this.id,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            // Get.to(() => ChatPage(
            //       userName: '$createdBy',
            //     ));
            // Trigger the notification when the "Connect" button is pressed
            sendConnectNotification();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: mainColor,
            minimumSize: const Size(200, 50),
          ),
          child: const Text(
            "Connect",
            style: TextStyle(color: kwhite, fontSize: 22),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        backgroundColor: mainColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.navigate_before,
            color: kwhite,
            size: 40,
          ),
        ),
        title: const Text(
          "Gig Details",
          style: TextStyle(
              color: kwhite, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 0),
        child: ListView(
          children: [
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: CustomAvatar(
                            radius: 40,
                            childSize: 40,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "$createdBy",
                          style: const TextStyle(
                              color: mainColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          offer ?? '',
                          style: const TextStyle(
                              color: mainColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const LocationIcon(
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        SubTitle(
                          subtitle: "$locaiton",
                          color: kgrey,
                          fontSize: 18,
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const ClockIcon(
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        SubTitle(
                          subtitle: "$time",
                          color: kgrey,
                          fontSize: 18,
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomTitle(title: "$category"),
                    DefaultTitle(title: "$title", color: mainColor),
                    SubTitle(
                      subtitle: "$description",
                      color: kgrey,
                      fontSize: 20,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                // Display the images from the photos list
                GigImageList(photos: photos),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendConnectNotification() async {
    try {
      // Retrieve the stored token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      if (authToken != null) {
        // Set up the POST request to send a connect notification
        var notificationUrl = Uri.parse("http://10.0.2.2:3000/api/gigs/$id");

        // Set the headers
        Map<String, String> notificationHeaders = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        };

        // Send the connect notification
        var notificationResponse = await http.post(
          notificationUrl,
          headers: notificationHeaders,
        );

        // Check if the connect notification request was successful
        if (notificationResponse.statusCode == 200) {
          log('Connect notification sent successfully.');

          // Now, set up the POST request to create a chat
          var chatUrl = Uri.parse("http://10.0.2.2:3000/api/chats/$userId");

          // Set the headers for creating a chat
          Map<String, String> chatHeaders = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          };

          // Set the data for creating a chat
          Map<String, dynamic> chatData = {
            'createdBy': createdBy,
            'content': 'Hello World',
          };

          // Send the request to create a chat
          var chatResponse = await http.post(
            chatUrl,
            headers: chatHeaders,
            body: jsonEncode(chatData),
          );

          // Check if the chat request was successful
          if (chatResponse.statusCode == 200) {
            log('Chat created successfully.');
          } else {
            log('Failed to create chat. Status code: ${chatResponse.statusCode}');
          }
        } else {
          log('Failed to send connect notification. Status code: ${notificationResponse.statusCode}');
        }
      }
    } catch (e) {
      log('Error sending connect notification: $e');
    }
  }
}
