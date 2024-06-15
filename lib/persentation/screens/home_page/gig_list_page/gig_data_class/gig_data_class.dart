import 'package:intl/intl.dart';

class Gig {
  final String title;
  final String category;
  final String description;
  final String createdBy;
  final double offer;
  final Map<String, dynamic> locationDetails;
  final List<String> photos;
  final String createdAt;
  final String locationName;
  final DateTime createdAtDateTime;
  // ignore: prefer_typing_uninitialized_variables
  final String id;
  final String userId;
  final DateTime timestamp; // Added timestamp field

  Gig({
    required this.title,
    required this.userId,
    required this.locationDetails,
    required this.category,
    required this.description,
    required this.createdBy,
    required this.offer,
    required this.photos,
    required this.id,
    required this.createdAt,
  })  : locationName = locationDetails['name'] ?? '',
        createdAtDateTime = DateTime.parse(createdAt),
        timestamp =
            DateTime.now(); // Initialize timestamp with the current time

  factory Gig.fromJson(Map<String, dynamic> json) {
    return Gig(
      userId: json['createdBy']['_id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      createdBy: json['createdBy']['name'] ?? '',
      offer: json['offer'] != null ? json['offer'].toDouble() : 0.0,
      locationDetails: {
        'latitude': json['location']['latitude'] ?? 0.0,
        'longitude': json['location']['longitude'] ?? 0.0,
        'name': json['location']['name'] ?? '',
      },
      photos: List<String>.from(json['photos'] ?? []),
      createdAt: json['createdAt'] ?? '',
      id: json['_id'],
    );
  }

  String formattedCreatedAt() {
    final formatter = DateFormat('HH:mm');
    return formatter.format(createdAtDateTime);
  }
}
