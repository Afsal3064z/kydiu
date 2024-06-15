import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/gap_manager.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/gig_controller/gig_details_page_controller.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/widgets/gig_detail_from.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/widgets/location_banner.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/widgets/photo_place_holder.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/widgets/pick_location_button.dart';

// This is the UI of the gig details page
class GigDetailsUI extends StatelessWidget {
  final String? currentLocation;
  final String? selectedLocation;
  final GigDetailsController controller;
  final String? selectedIconName;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GigDetailsUI({
    super.key, // Corrected parameter name from super.key to key
    this.currentLocation,
    this.selectedLocation,
    required this.controller,
    this.selectedIconName,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        children: [
          GigDetailFrom(
              formKey: _formKey,
              selectedIconName: selectedIconName,
              controller: controller),

          kheight20,
          // This is the column for adding photos of the gig
          Column(
            children: controller.selectedImages.isEmpty
                ? [
                    // Display a message or placeholder when no images are added
                    const PhotoPlaceHolder(),
                  ]
                //This is the list generated when photos are added in the application
                : List.generate(
                    controller.selectedImages.length,
                    (index) {
                      var image = controller.selectedImages[index];
                      return image != null
                          ? Column(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.file(
                                        image,
                                        width: 400,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: mainColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              _showDeleteDialog(
                                                  context, index, controller);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                kheight10,
                              ],
                            )
                          : const SizedBox.shrink();
                    },
                  ),
          ),

          // This is to check the visibility of the button when the user has added 3 photos
          if (controller.selectedImages.length < 2) kheight10,
          Visibility(
            visible: controller.selectedImages.length < 2,
            child: ElevatedButton(
              onPressed: () => _showImagePickerModal(context, controller),
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
                'Add Photo',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),

          kheight10,
          kheight20,
          // This is the widget to show the location picked by the user
          LocationBanner(
            currentLocation: currentLocation.toString(),
            controller: controller,
          ),
          kheight10,
          // This is the button to pick the location in the application
          PickLocationButton(controller: controller),
          kheight80,
        ],
      ),
    );
  }

  // This method shows the option to the user to select a photo from the gallery or from the camera
  void _showImagePickerModal(
      BuildContext context, GigDetailsController controller) {
    controller.showImagePickerModal(context);
  }

  // This method shows the dialog box to delete the photo the user had added
  void _showDeleteDialog(
      BuildContext context, int index, GigDetailsController controller) {
    controller.showDeleteDialog(context, index);
  }
}
