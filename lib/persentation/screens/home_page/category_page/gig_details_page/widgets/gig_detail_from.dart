import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/gap_manager.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/gig_controller/gig_details_page_controller.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/widgets/gig_from_field.dart';

//This is the gig form where the user can add the details about the gig in the app...
class GigDetailFrom extends StatelessWidget {
  const GigDetailFrom({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.selectedIconName,
    required this.controller,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final String? selectedIconName;
  final GigDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //This is the widget that show the category of the gig...
          Text(
            "Category :  $selectedIconName",
            style: const TextStyle(
              color: mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          kheight20,
          //This is the from to enter the title of the gig by the user..2
          GigFromField(
            controller: controller.titleController,
            title: 'Title',
            acceptOnlyNumbers: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              } else if (value.length < 5) {
                return 'Title must be at least 5 characters';
              }
              return null; // Return null for no validation errors
            },
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
          kheight10,
          // This is the form for adding description for the gig
          GigFromField(
            controller: controller.descriptionController,
            title: "Description",
            acceptOnlyNumbers: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a description";
              } else if (value.length < 5) {
                return "Description must be at least 5 characters";
              }
              return null;
            },
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
          kheight10,
          // This is the form for adding offer price for the gig
          GigFromField(
            controller: controller.offerController,
            title: "Offer",
            prefixText: "\$",
            acceptOnlyNumbers: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an offer';
              }
              return null; // Return null for no validation errors
            },
          ),
        ],
      ),
    );
  }
}
