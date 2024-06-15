import 'dart:io';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/data_class/location_data.dart';

//This is the data class for gig data
class GigData {
  String category;
  String title;
  String description;
  double offer;
  List<File?> photos;
  Location? location;

  GigData({
    required this.category,
    required this.title,
    required this.description,
    required this.offer,
    required this.photos,
    this.location,
  });
}
