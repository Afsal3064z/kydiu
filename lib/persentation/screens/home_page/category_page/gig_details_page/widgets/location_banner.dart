import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/gig_controller/gig_details_page_controller.dart';

//This is the location banner were the  user can add locatoin in the application
class LocationBanner extends StatelessWidget {
  final String? currentLocation;
  const LocationBanner({
    super.key,
    required this.controller,
    this.currentLocation,
  });

  final GigDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedLocation = controller.selectedLocation.value;

      // Check if no location is selected
      if (selectedLocation.isEmpty) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: mainColor,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'No location selected',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: mainColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      // Show the selected location banner
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: mainColor,
                  ),
                  Text(
                    "selectedLocation : ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: mainColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Text(
                selectedLocation,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: mainColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    });
  }
}
