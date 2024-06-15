import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/text_manager.dart';
import 'package:kydu/persentation/screens/chat_page/chat_page_controller/chat_page_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String receiverId;
  final String? authToken;

  const ChatPage({
    super.key,
    required this.userName,
    required this.receiverId,
    this.authToken,
  });

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  ChatController? controller;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        controller = ChatController(prefs, widget.receiverId);
        controller!.fetchChats(prefs, widget.receiverId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: controller!.chatsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final chats = snapshot.data;

                if (chats == null || chats.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildChatsList(chats);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (messageController.text.isNotEmpty) {
                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // _sendMessage(
                      //   widget.authToken.toString(),
                      //   widget.receiverId,
                      //   messageController.text,
                      // );
                    }
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String authToken, String receiverId, String message) async {
    try {
      if (controller != null) {
        // Send the message using the controller
        await controller!.sendMessage(authToken, receiverId, message);

        // Fetch chats after sending the message
        SharedPreferences prefs = await SharedPreferences.getInstance();
        controller!.fetchChats(prefs, widget.receiverId);
      }
    } catch (error) {
      log('Error sending message: $error');
      // Handle the error, if any
    } finally {
      messageController.clear();
    }
  }

  Widget _buildChatsList(List<String> chats) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                chats[index],
                style: const TextStyle(color: kwhite),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DefaultTitle(
            title: "No chats available.",
            color: mainColor,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
