import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/category_page/category_page.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/data_class/gig_data.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/data_class/location_data.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/gig_controller/gig_details_page_controller.dart';

// This is the button to post the gig
class GigPostButton extends StatelessWidget {
  final String? category;
  const GigPostButton(
      {super.key,
      required this.controller,
      required this.formKey,
      required this.category});

  final GigDetailsController controller;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Log the value to check
        controller
            .getAllGigData(); // Ensure location is fetched before accessing it
        log("Selected Location Coordinates: ${controller.selectedLocation.value}");
        log('Offer: ${controller.offerController.text}');
        log('Description: ${controller.descriptionController.text}');
        log('Selected Images: ${controller.selectedImages}');

        // Validate the form
        if (controller.offerController.text.isEmpty ||
            controller.descriptionController.text.isEmpty ||
            controller.selectedImages.isEmpty ||
            controller.selectedLocation.value.isEmpty) {
          // If form is not valid, show an error message or handle it accordingly
          // For example, you can display a snackbar
          Get.snackbar(
            'Error',
            'Please fill in all required fields and fix validation errors.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          // If form is valid, proceed with posting the gig
          // Create a GigData object with the necessary data
          GigData gigData = GigData(
            title: controller.titleController.text,
            description: controller.descriptionController.text,
            offer: double.parse(controller.offerController.text),
            photos: controller.selectedImages.toList(),
            location: Location(
              latitude: controller.selectedCordinates.value?.latitude ?? 0.0,
              longitude: controller.selectedCordinates.value?.longitude ?? 0.0,
              name: controller.selectedLocation.value,
            ),
            category: category.toString(),
          );
          log('GigData being posted: ${gigData.toString()}');
          // Pass the GigData object to the postGig method
          await controller.postGig(gigData);
          // Navigate to HomePage only after successful gig posting
          Get.off(() => CategoryPage());
          Get.snackbar(
            'Gig Post Successfull',
            " You successfully posted the gig",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: mainColor,
            colorText: Colors.white,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        backgroundColor: mainDarkColor,
        foregroundColor: kwhite,
        elevation: 0,
        fixedSize: Size(MediaQuery.of(context).size.width, 60),
      ),
      child: const Text(
        'Post',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
