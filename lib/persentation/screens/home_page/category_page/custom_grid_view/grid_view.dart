// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/gap_manager.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/category_page/category_page_controller.dart';

class MyGridView extends StatefulWidget {
  final void Function(String iconName)? onIconSelected;
  final CategoryController categoryController;

  const MyGridView({
    super.key,
    this.onIconSelected,
    required this.categoryController,
  });

  @override
  MyGridViewState createState() => MyGridViewState();
}

class MyGridViewState extends State<MyGridView> {
  final List<String> icons = [
    "lib/assets/settings 1.png",
    "lib/assets/plumber 1.png",
    "lib/assets/planting 1.png",
    "lib/assets/paint-roller 1.png",
    "lib/assets/mechanic 1.png",
    "lib/assets/lift 1.png",
    "lib/assets/driller 1.png",
    "lib/assets/hammer 1.png",
    "lib/assets/delivery 1.png",
    "lib/assets/box 1.png",
    "lib/assets/cleaning-staff 1.png",
    "lib/assets/idea 1.png",
  ];

  final List<String> iconNames = [
    "Settings",
    "Plumber",
    "Planting",
    "Paint Roller",
    "Mechanic",
    "Lift",
    "Driller",
    "Hammer",
    "Delivery",
    "Box",
    "Cleaning Staff",
    "Idea",
  ];

  int selectedIconIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: icons.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedIconIndex = index;

                    if (widget.onIconSelected != null) {
                      widget.onIconSelected!(iconNames[index]);
                    }

                    widget.categoryController.setIconName(iconNames[index]);
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.identity()
                    ..scale(selectedIconIndex == index ? 1.05 : 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kwhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedIconIndex == index
                            ? mainColor
                            : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(icons[index]),
                            kheight10,
                            Center(
                              child: Text(
                                iconNames[index],
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (selectedIconIndex == index)
                          const Positioned(
                            top: 5,
                            right: 5,
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
