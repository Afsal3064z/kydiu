// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart'; // Import this for date formatting

import 'package:shared_preferences/shared_preferences.dart';

import 'package:kydu/const/api_provider/api_provider.dart';

class Alert {
  final String title;
  final String message;
  final String time;

  Alert({
    required this.title,
    required this.message,
    required this.time,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    return Alert(
      title: json['title'] ?? '',
      message: json['content'] ?? '',
      time: json['createdAt'] ?? '',
    );
  }

  Alert copyWith({
    String? title,
    String? message,
    String? time,
  }) {
    return Alert(
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'message': message,
      'time': time,
    };
  }

  factory Alert.fromMap(Map<String, dynamic> map) {
    return Alert(
      title: map['title'] as String,
      message: map['message'] as String,
      time: map['time'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Alert.fromJsonString(String source) =>
      Alert.fromMap(json.decode(source) as Map<String, dynamic>);

  String timeAgo() {
    final DateTime now = DateTime.now();
    final DateTime alertTime = DateTime.parse(time);
    final Duration difference = now.difference(alertTime);

    if (difference.inDays > 0) {
      return DateFormat('MMM d, yyyy').format(alertTime);
    } else {
      return DateFormat.Hm().format(alertTime); // Display hours and minutes
    }
  }

  @override
  String toString() => 'Alert(title: $title, message: $message, time: $time)';

  @override
  bool operator ==(covariant Alert other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.message == message &&
        other.time == time;
  }

  @override
  int get hashCode => title.hashCode ^ message.hashCode ^ time.hashCode;
}

class AlertController {
  late List<Alert> alerts = [];
  final ApiProvider apiProvider = ApiProvider('http://10.0.2.2:3000/api');

  bool isLoading = false;
  bool isFetching = false;
  bool isAlertsFetched = false;
  bool _hasAlerts = false;

  bool get hasAlerts => _hasAlerts;

  final _alertsStreamController = StreamController<List<Alert>>.broadcast();

  Stream<List<Alert>> get alertsStream => _alertsStreamController.stream;

  late Timer _longPollingTimer;

  AlertController() {
    _longPollingTimer = Timer(Duration.zero, () {});

    _startLongPolling();
  }

  void _startLongPolling() {
    _longPollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchAlerts();
    });
  }

  void debouncedFetchAlerts(String searchTerm) {
    fetchAlerts();
  }

  void fetchAlerts() async {
    try {
      if (isFetching) {
        return;
      }

      isFetching = true;
      isLoading = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      if (authToken != null) {
        final response = await apiProvider.getAlerts(authToken);
        log(response.body);

        if (response.statusCode == 429) {
          log("🛑 You're calling the API too many times in rapid succession.");

          throw Exception(
              "Ratelimit exceeded, cannot make any more API Requests");
        }

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);

          if (responseData.containsKey('alerts')) {
            final List<dynamic> jsonData = responseData['alerts'] ?? [];
            alerts = jsonData
                .map((json) => Alert.fromJson(json))
                .toList()
                .reversed
                .toList();

            isAlertsFetched = true;
            _hasAlerts = alerts.isNotEmpty;

            _alertsStreamController.add(alerts);
          } else {
            throw Exception('No "alerts" key found in the response.');
          }
        } else {
          throw Exception('Failed to fetch alerts: ${response.statusCode}');
        }
      } else {
        throw Exception('AuthToken is null');
      }
    } catch (error, stackTrace) {
      log('Error: $error\n$stackTrace');
      if (error is SocketException || error is HttpException) {
        log('Network error: Unable to fetch alerts. Please check your internet connection.');
      } else {
        log('Unknown error occurred while fetching alerts.');
      }
    } finally {
      isLoading = false;
      isFetching = false;
    }
  }

  void dispose() {
    _longPollingTimer.cancel();
    _alertsStreamController.close();
  }

  void setIsFetching(bool bool) {}
}
