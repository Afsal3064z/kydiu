import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/gig_controller/gig_details_page_controller.dart';
import 'package:kydu/persentation/screens/home_page/location_picker_screen/location_picker_screen.dart';

class PickLocationButton extends StatelessWidget {
  const PickLocationButton({
    super.key,
    required this.controller,
  });

  final GigDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final selectedLocation = await Get.to(() => LocationSearchPage());
        if (selectedLocation != null) {
          controller.selectedLocation.value = selectedLocation;
          controller.update(); // Ensure that the controller updates the UI
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: mainColor,
        foregroundColor: kwhite,
        elevation: 0,
        fixedSize: Size(MediaQuery.of(context).size.width, 60),
      ),
      child: const Text(
        'Pick Location',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
