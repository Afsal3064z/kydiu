import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/gap_manager.dart';
import 'package:kydu/persentation/screens/home_page/category_page/custom_grid_view/grid_view.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/category_page/category_page_controller.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/gig_details_page.dart';

//This is the  main category page to show the grid view of the category of the gigs in the app
class CategoryPage extends StatelessWidget {
  final CategoryController categoryController = Get.put(CategoryController());
  CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          leading: IconButton(
            icon: const Icon(
              Icons.navigate_before,
              color: kwhite,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Category",
            style: TextStyle(color: kwhite, fontSize: 25),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              kheight20,
              Expanded(
                //This is the custom grid view for the app
                child: MyGridView(
                    onIconSelected: (iconName) {
                      // Handle icon selection
                      log('Selected Icon: $iconName');
                    },
                    categoryController: categoryController),
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                  onPressed: () {
                    String selectedIconName =
                        categoryController.selectedIconName.value;
                    if (selectedIconName.isEmpty) {
                      // Show a snackbar message if the icon name is empty
                      Get.snackbar(
                        "Select a Category",
                        "Please select a category before continuing",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else {
                      // Navigate to GigDetailsPage with the selected icon name
                      Get.off(() =>
                          GigDetailsPage(selectedIconName: selectedIconName));
                    }
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: kwhite, fontSize: 20),
                  ),
                ),
              ),
              kheight20
            ],
          ),
        ),
      ),
    );
  }
}
