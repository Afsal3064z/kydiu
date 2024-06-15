import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProfileController {
  final String baseUrl;

  UserProfileController(this.baseUrl);

  Future<Map<String, dynamic>> fetchUserProfile(String authToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch user profile: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching user profile: $error');
    }
  }
}
