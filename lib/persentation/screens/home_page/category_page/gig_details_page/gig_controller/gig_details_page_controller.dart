import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/data_class/gig_data.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/data_class/location_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GigDetailsController extends GetxController {
  GigDetailsController({
    required this.category,
  });

  final TextEditingController titleController =
      TextEditingController(); //This is the controller  for the title [gig]
  final TextEditingController descriptionController =
      TextEditingController(); //This is the controller for the description [gig]
  final TextEditingController offerController =
      TextEditingController(); //This is the controller for the offer [gig]
  final Rx<File?> selectedImage =
      Rx<File?>(null); //This is the selected image [gig]
  final RxString selectedLocation =
      ''.obs; //This is the selected location by the user [gig]
  Rx<Position?> selectedCordinates =
      Rx<Position?>(null); //This is the selected cordinates by the user [gig]
  final Rx<double?> selectedLatitude =
      Rx<double?>(null); //This is the selected latitude by the user [gig]
  final Rx<double?> selectedLongitude =
      Rx<double?>(null); //This is the selected longitude by the user [gig]
  final RxList<File?> selectedImages = <File?>[]
      .obs; //This is the selected image in the file path [gig] [mentioned // for temporary]
  final Completer<GoogleMapController> mapController = Completer<
      GoogleMapController>(); //This is the controller of the google map
  String category;

  @override
  @override

  //This is to update the cordinates in the ui
  void onInit() {
    super.onInit();

    // Listen for changes in selectedCordinates and update the UI
    ever<Position?>(selectedCordinates, (Position? coordinates) {
      log('Selected Coordinates changed: $coordinates');
      // You can update the UI or perform actions here
    });
  }

  void clearCategory() {
    category = '';
  }

//This is the update the selected location in the  location
  void setSelectedLocation(String location) {
    selectedLocation.value = location;
    log("Selected location name in the gig details controller : $location");
  }

//This is to update the selected latitude in the latitude
  void setSelectedLatitude(double latitude) {
    selectedLatitude.value = latitude;
    log("Selected location latitude in the gig details controller : $latitude");
  }

//This is to update the seleted longitude in the longitude
  void setSelectedLongitude(double longitude) {
    selectedLongitude.value = longitude;
    log("Selected location longitude in the gig details controller : $longitude");
  }

//This is the methode to post the gig in the server
  Future<void> postGig(GigData gigData) async {
    try {
      // Retrieve the stored token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      if (authToken != null) {
        // Create the gig data from the controller's state
        GigData gigData = GigData(
          title: titleController.text,
          description: descriptionController.text,
          offer: double.tryParse(offerController.text) ?? 0.0,
          photos: selectedImages.toList(),
          location: Location(
            latitude: selectedLatitude.value ?? 0.0,
            longitude: selectedLongitude.value ?? 0.0,
            name: selectedLocation.value,
          ),
          category: category,
        );

        var request = http.MultipartRequest(
            "POST", Uri.parse("http://10.0.2.2:3000/api/gigs"));

        request.fields["category"] = gigData.category;
        request.fields["title"] = gigData.title;
        request.fields["description"] = gigData.description;
        request.fields["offer"] = gigData.offer.toString();
        request.fields["location[latitude]"] =
            (gigData.location?.latitude ?? 0.0).toString();
        request.fields["location[longitude]"] =
            (gigData.location?.longitude ?? 0.0).toString();
        request.fields["location[name]"] = gigData.location?.name as String;

        if (selectedImages.isNotEmpty) {
          for (int i = 0; i < selectedImages.length; i++) {
            request.files.add(http.MultipartFile.fromBytes(
                'images[$i]', await selectedImages[i]!.readAsBytes(),
                filename: selectedImages[i]!.path,
                contentType: MediaType('image', 'jpeg')));
          }
        }

        Map<String, String> headers = {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken"
        };

        request.headers.addAll(headers);

        request.send().then((response) {
          if (response.statusCode == 200) log("Gig posted!");
        });
      } else {
        // Handle case where the token is null
        log('Error: AuthToken is null');
      }
    } catch (error) {
      // Handle other errors
      log('Error: $error');
    }
  }

//This is the methode to add new image for the  gig details
  void addNewImage(File newImage) {
    selectedImages.add(newImage);
    update(); // Ensure that this is called to trigger UI update
  }

//This is the methode to pick image from the device
  Future<void> pickImage(ImageSource source) async {
    List<XFile>? images = await ImagePicker().pickMultiImage();
    selectedImages.addAll(images.map((image) => File(image.path)));
  }

//This is the methode to show the model for the option to pic the image from the   gallery or camera
  Future<void> showImagePickerModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                await pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  selectedImages.add(File(image.path));
                }
              },
            ),
          ],
        );
      },
    );
  }

//This is the alert box for deleting added image in the gig details page
  Future<void> showDeleteDialog(BuildContext context, int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Photo'),
          content: const Text('Are you sure you want to delete this photo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                selectedImages.removeAt(index);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

//This is the methode for the auto complete of the place in the location picker page
  Future<void> onMapCreated(GoogleMapController controller) async {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
  }

//This is the methode to validate the from in the  gig details page
  bool validateForm() {
    if (titleController.text.isEmpty || titleController.text.length < 5) {
      // Check if title is empty or less than 5 characters
      log('Title is invalid');
      return false;
    }

    if (descriptionController.text.isEmpty ||
        descriptionController.text.length < 5) {
      // Check if description is empty or less than 5 characters
      log('Description is invalid');
      return false;
    }

    if (offerController.text.isEmpty ||
        double.tryParse(offerController.text) == null) {
      // Check if offer is empty or not a valid number
      log('Offer is invalid');
      return false;
    }

    if (selectedImages.isEmpty ||
        selectedImages.any((image) => image == null)) {
      // Check if at least one image is selected
      log('Please select at least one image');
      return false;
    }

    if (selectedLocation.value.isEmpty) {
      // Check if location is empty
      log('Location is invalid');
      return false;
    }

    return true; // Form is valid
  }

  Map<String, dynamic> getAllGigData() {
    return {
      'title': titleController.text,
      'description': descriptionController.text,
      'offer': double.tryParse(offerController.text) ?? 0.0,
      'photos': selectedImages.map((file) => file?.path).toList(),
      'location': {
        'latitude': selectedLatitude.value ?? 0.0,
        'longitude': selectedLongitude.value ?? 0.0,
        'name': selectedLocation.value,
      },
    };
  }
}
