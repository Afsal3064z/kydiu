import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';

//This is the list tile were the location result will be listed
//in the plication when the user search for a specific place
class LocationListTile extends StatelessWidget {
  const LocationListTile(
      {super.key,
      required this.location,
      required this.press,
      required this.onLocationSelected});
  final String location;
  final Function(String) onLocationSelected;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            onLocationSelected(location);
            Get.back(result: location); // Pass the selected location back
          },
          horizontalTitleGap: 0,
          leading: const Icon(
            Icons.location_on,
            size: 30,
            color: mainColor,
          ),
          title: Text(
            location,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Divider(
          height: 2,
          thickness: 2,
          color: Colors.grey.shade200,
        )
      ],
    );
  }
}
