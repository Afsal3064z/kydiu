import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/home_page/bottom_nav/home_page.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/category_page/category_page_controller.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/gig_controller/gig_details_page_controller.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/gig_detaiils_ui.dart';
import 'widgets/gig_post_button.dart';

//This is the gig details page where the user can add the details of the gig they are going to post
class GigDetailsPage extends StatelessWidget {
  final String? selectedLocation;
  final double? selectedLatitude;
  final double? selectedLongitude;
  final double? currentLatitude;
  final double? currentLongitude;
  final String? selectedIconName;

  // Create a GlobalKey<FormState> for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GigDetailsPage({
    super.key,
    this.selectedLocation,
    this.selectedLatitude,
    this.selectedLongitude,
    this.currentLatitude,
    this.currentLongitude,
    this.selectedIconName,
  });

  @override
  Widget build(BuildContext context) {
    final GigDetailsController controller =
        Get.put(GigDetailsController(category: selectedIconName.toString()));
    final CategoryController categoryController = Get.put(CategoryController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Pop until the home page is reached
            Get.off(() => HomePage());
            // Clear the category when leaving the page
            categoryController.onClose();
          },
          icon: const Icon(
            Icons.navigate_before,
            color: mainColor,
            size: 40,
          ),
        ),
        title: const Text(
          'Gig Details',
          style: TextStyle(
              color: mainColor, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      // Pass the form key to GigDetailsUI and GigPostButton
      //This is the gig post button
      floatingActionButton: GigPostButton(
        controller: controller,
        formKey: _formKey,
        category: selectedIconName,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<GigDetailsController>(builder: (controller) {
          //This is the UI of the gig details page
          return GigDetailsUI(
            selectedIconName: selectedIconName,
            selectedLocation: selectedLocation,
            controller: controller,
            key: _formKey, // Pass the form key to GigDetailsUI
          );
        }),
      ),
    );
  }
}
