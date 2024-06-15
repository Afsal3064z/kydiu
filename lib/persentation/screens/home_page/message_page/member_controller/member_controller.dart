// member_controller.dart

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:kydu/const/api_provider/api_provider.dart';
import 'package:kydu/persentation/screens/home_page/message_page/member_data/member_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberController {
  late List<Member> members = [];
  final ApiProvider apiProvider = ApiProvider('http://10.0.2.2:3000/api');

  bool isLoading = false;
  bool isFetching = false;

  final _membersStreamController = StreamController<List<Member>>.broadcast();

  Stream<List<Member>> get membersStream => _membersStreamController.stream;

  late Timer _longPollingTimer;

  MemberController() {
    _longPollingTimer = Timer(Duration.zero, () {});
    _startLongPolling();
  }

  void _startLongPolling() {
    _longPollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!isFetching) {
        fetchMembers();
      }
    });
  }

  void fetchMembers() async {
    try {
      if (isFetching) {
        return;
      }

      isFetching = true;
      isLoading = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      if (authToken != null) {
        final response = await apiProvider.getMembers(authToken);

        if (response.statusCode == 200) {
          final List<dynamic> jsonData = json.decode(response.body);
          log('API response: $jsonData');

          members = jsonData.map((json) {
            return Member(
              id: json['_id'] ?? '',
              sender: json['sender']['name'] ?? '',
              receiver: json['receiver']['name'] ?? '',
              approved: json['approved'] ?? false,
              createdAt: json['createdAt'] ?? '',
              username: '',
              status: '',
              senterId: json['sender']['_id'] ?? '',
              reciverId: json['receiver']['_id'] ?? '',
            );
          }).toList();

          // Notify the stream about the updated list
          _membersStreamController.add(members);
        } else {
          log('Failed to fetch members. Status code: ${response.statusCode}');
          throw Exception('Failed to fetch members: ${response.statusCode}');
        }
      } else {
        log('AuthToken is null');
        throw Exception('AuthToken is null');
      }
    } catch (error) {
      log('Error in fetchMembers: $error');
    } finally {
      isLoading = false;
      isFetching = false;
    }
  }

  void dispose() {
    _longPollingTimer.cancel();
    _membersStreamController.close();
  }
}
