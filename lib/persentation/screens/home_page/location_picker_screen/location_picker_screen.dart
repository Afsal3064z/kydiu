import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/home_page/location_picker_screen/location_picker_controller/location_picker_controller.dart';
import 'package:kydu/persentation/screens/home_page/location_picker_screen/widget/location_list_tile.dart';

//This is the page to search the place where  the user can  search out the places
class LocationSearchPage extends StatelessWidget {
  final LocationSearchController controller =
      Get.put(LocationSearchController());

  LocationSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.navigate_before,
            color: mainColor,
            size: 40,
          ),
        ),
        title: const Text(
          "Set Your Location",
          style: TextStyle(
            color: mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Form(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      style: const TextStyle(color: mainColor),
                      onChanged: (value) {
                        controller.placeAutoComplete(value);
                      },
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: mainColor, width: 10),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Search Your location",
                        hintStyle: const TextStyle(color: kgrey),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Icon(
                            Icons.location_on,
                            color: mainColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey.shade200,
                height: 4,
                thickness: 4,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.fetchCurrentLocation();
                  },
                  icon: const Icon(
                    Icons.location_on,
                    size: 30,
                  ),
                  label: const Text(
                    "Use my current Location",
                    style: TextStyle(color: kwhite, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: mainColor,
                    foregroundColor: kwhite,
                    elevation: 0,
                    fixedSize: Size(MediaQuery.of(context).size.width, 60),
                  ),
                ),
              ),
              Divider(
                height: 4,
                thickness: 4,
                color: Colors.grey.shade200,
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.placePredictions.length,
                    itemBuilder: (context, index) => LocationListTile(
                      location: controller.placePredictions[index].description!,
                      press: () {},
                      onLocationSelected: (selectedLocation) {
                        controller.handleLocationSelection(selectedLocation);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => Visibility(
              visible: controller.isFetchingLocation.value,
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
