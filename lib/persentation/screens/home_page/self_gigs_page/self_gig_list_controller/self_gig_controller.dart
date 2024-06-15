import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kydu/const/api_provider/api_provider.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/gig_data_class/gig_data_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelfGigListController {
  late List<Gig> gigs = [];
  final ApiProvider apiProvider = ApiProvider('http://10.0.2.2:3000/api');

  bool isLoading = false;
  bool isFetching = false;
  bool isGigsFetched = false;

  final _gigsStreamController = StreamController<List<Gig>>.broadcast();

  Stream<List<Gig>> get gigsStream => _gigsStreamController.stream;

  late Timer _longPollingTimer;

  SelfGigListController() {
    // Initialize with a dummy Timer
    _longPollingTimer = Timer(Duration.zero, () {});

    // Start long polling when the controller is created
    _startLongPolling();
  }

  void _startLongPolling() {
    // Fetch gigs every 5 seconds using a periodic timer
    _longPollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchGigs();
    });
  }

  void debouncedFetchGigs(String searchTerm) {
    // Debounced fetchGigs method
    fetchGigs();
  }

  void fetchGigs() async {
    try {
      if (isFetching) {
        return;
      }

      isFetching = true;
      isLoading = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      if (authToken != null) {
        log('Fetching gigs with authToken: $authToken'); // Log authToken for debugging
        final response = await apiProvider.getSelfGigs(authToken);

        if (response.statusCode == 429) {
          log("🛑 You're calling the API too many times in rapid succession.");

          throw Exception(
              "Ratelimit exceeded, cannot make any more API Requests");
        }

        if (response.statusCode == 200) {
          final List<dynamic> jsonData = json.decode(response.body);
          gigs = jsonData
              .map((json) => Gig.fromJson(json))
              .toList()
              .reversed
              .toList();
          isGigsFetched = true;

          // Add new gigs to the stream
          _gigsStreamController.add(gigs);
        } else {
          throw Exception('Failed to fetch gigs: ${response.statusCode}');
        }
      } else {
        debugPrint('Error: AuthToken is null');
      }
    } catch (error) {
      log('Error: $error');
      if (error is SocketException || error is HttpException) {
        log('Network error: Unable to fetch gigs. Please check your internet connection.');
      } else {
        log('Unknown error occurred while fetching gigs.');
      }
    } finally {
      isLoading = false;
      isFetching = false;
    }
  }

  void dispose() {
    // Cancel the long polling timer and close the stream controller when the controller is disposed
    _longPollingTimer.cancel();
    _gigsStreamController.close();
  }

  void setIsFetching(bool bool) {}
}

class Debouncer<T> {
  final Duration delay;
  late void Function(T value) onValue;
  late T lastValue;
  Timer? _timer;

  Debouncer(this.delay);

  void call(T value) {
    lastValue = value;
    _timer?.cancel();
    _timer = Timer(delay, () => onValue(lastValue));
  }
}
