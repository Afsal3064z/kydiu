import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiProvider {
  final String baseUrl;

  ApiProvider(this.baseUrl);

  Future<http.Response> getProfile(String authToken) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/profile'), //This is the base url to get the user profile in the application
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken'
      },
    );
    return response;
  }

  Future<http.Response> postGig(
    String authToken,
    Map<String, dynamic> gigData,
  ) async {
    final response = await http.post(
      Uri.parse(
          '$baseUrl/gigs'), // this is the base url to post the gig in the application
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(gigData),
    );
    return response;
  }

  Future<http.Response> getGigs(String authToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/gigs'), // this is the base url to get gigs
      // when ur puting coordinates
      // '$baseUrl/gigs?latitude=$lat&longitude=$long')
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    return response;
  }

  Future<http.Response> getSelfGigs(String authToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/gigs?self=true'), // this is the base url to get gigs
      // when ur puting coordinates
      // '$baseUrl/gigs?latitude=$lat&longitude=$long')
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    return response;
  }

  Future<http.Response> getAlerts(String authToken) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/profile?alertsOnly=true'), //This is the url to get the alerts
      //Need to check on this...
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    return response;
  }

  Future<http.Response> getMembers(String authToken) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/chats'), // Replace 'members' with your actual endpoint for fetching members
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    return response;
  }

  Future<http.Response> getChats(String authToken, String receiverId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chats/$receiverId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    return response;
  }

  Future<http.Response> postMessage(
      String authToken, String receiverId, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chats/$receiverId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 401) {
      // Handle unauthorized (e.g., refresh token or navigate to login)
      // Example: refreshToken();
      // Example: navigateToLogin();
    }

    return response;
  }
}
