// chat_controller.dart

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:kydu/const/api_provider/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController {
  final ApiProvider apiProvider = ApiProvider('http://10.0.2.2:3000/api');

  bool isLoading = false;
  bool isFetching = false;

  final _chatsStreamController = StreamController<List<String>>.broadcast();

  Stream<List<String>> get chatsStream => _chatsStreamController.stream;

  late Timer _longPollingTimer;

  ChatController(SharedPreferences prefs, String receiverId) {
    _longPollingTimer = Timer(Duration.zero, () {});
    _startLongPolling(prefs, receiverId);
  }

  void _startLongPolling(SharedPreferences prefs, String receiverId) {
    _longPollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!isFetching) {
        fetchChats(prefs, receiverId);
      }
    });
  }

  Future<void> fetchChats(SharedPreferences prefs, String receiverId) async {
    try {
      if (isFetching) {
        return;
      }

      isFetching = true;
      isLoading = true;

      // Retrieve the authToken from SharedPreferences
      String? authToken = prefs.getString('authToken');

      if (authToken != null) {
        final response = await apiProvider.getChats(authToken, receiverId);

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonData = json.decode(response.body);

          // Ensure jsonData contains the "messages" key and its value is a List
          if (jsonData.containsKey('messages') &&
              jsonData['messages'] is List) {
            final List<dynamic> messagesJson = jsonData['messages'];
            final List<String> chats =
                messagesJson.map((json) => json['content'].toString()).toList();

            // Notify the stream about the updated list
            _chatsStreamController.add(chats);
          } else {
            log('Invalid response structure. Expected "messages" key with a List value, but got: $jsonData');
          }
        } else {
          log('Failed to fetch chats. Status code: ${response.statusCode}');
          throw Exception('Failed to fetch chats: ${response.statusCode}');
        }
      } else {
        log('AuthToken is null');
        throw Exception('AuthToken is null');
      }
    } catch (error) {
      log('Error in fetchChats: $error');
    } finally {
      isLoading = false;
      isFetching = false;
    }
  }

 Future<void> sendMessage(String authToken, String receiverId, String message) async {
  try {
    final response = await apiProvider.postMessage(authToken, receiverId, message);

    if (response.statusCode == 201) {
      log('Message sent successfully');
      // Fetch chats after sending a message
      fetchChats(authToken as SharedPreferences, receiverId);
    } else if (response.statusCode == 401) {
      // Handle unauthorized (e.g., refresh token or navigate to login)
      // Example: refreshToken();
      // Example: navigateToLogin();
    } else {
      log('Failed to send message. Status code: ${response.statusCode}');
      throw Exception('Failed to send message: ${response.statusCode}');
    }
  } catch (error) {
    log('Error in sendMessage: $error');
    throw Exception('Error in sendMessage: $error');
  }
}


  void dispose() {
    _longPollingTimer.cancel();
    _chatsStreamController.close();
  }
}
