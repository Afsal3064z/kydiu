import 'dart:convert';
import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/gig_controller/gig_details_page_controller.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/gig_details_page.dart';
import 'package:kydu/persentation/screens/home_page/location_picker_screen/network_utilities/network_utilities.dart';
import 'package:kydu/persentation/screens/home_page/location_picker_screen/network_utilities/place_auto_complete_response.dart';

class LocationSearchController extends GetxController {
  RxList<AutocompletePrediction> placePredictions =
      <AutocompletePrediction>[].obs;
  RxBool isFetchingLocation = false.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  Future<void> getCurrentLocation() async {
    try {
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!isLocationServiceEnabled) {
        log('Location services are not enabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          log('Location permission denied.');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      String locationName =
          await getLocationNameFromCoordinates(latitude.value, longitude.value);

      if (locationName == "Unknown") {
        locationName = await getNearbyPOIName(latitude.value, longitude.value);
      }

      log('Current Location: Latitude - $latitude, Longitude - $longitude, Location Name - $locationName');
    } catch (e) {
      log('Error getting current location: $e');
    }
  }

  void placeAutoComplete(String query) async {
    Uri uri =
        Uri.https("maps.googleapis.com", 'maps/api/place/autocomplete/json', {
      "input": query,
      "key": apiKey,
    });

    String? response = await NetWorkUtility.fetchUrl(uri);
    if (response != null) {
      log(response);
      PlaceAutoCompleteResponse result =
          PlaceAutoCompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        placePredictions.assignAll(result.predictions!);
      }
    }
  }

  Future<void> fetchCurrentLocation() async {
    try {
      isFetchingLocation.value = true;
      await getCurrentLocation();

      String locationName =
          await getLocationNameFromCoordinates(latitude.value, longitude.value);

      if (locationName == "Unknown") {
        locationName = await getNearbyPOIName(latitude.value, longitude.value);
      }

      GigDetailsController gigDetailsController =
          Get.find<GigDetailsController>();
      log('Current Location: Latitude - $latitude, Longitude - $longitude, Location Name - $locationName');
      gigDetailsController.setSelectedLatitude(latitude.value);
      gigDetailsController.setSelectedLongitude(longitude.value);
      gigDetailsController.setSelectedLocation(locationName);

      Get.off(() => GigDetailsPage(
            selectedLongitude: longitude.value,
            selectedLatitude: latitude.value,
            selectedLocation: locationName,
          ));
      Get.back();
    } catch (e) {
      log('Error getting current location: $e');
    } finally {
      isFetchingLocation.value = false;
    }
  }

  Future<String> getLocationNameFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        String locationName = place.locality ?? "Unknown";

        if (place.subLocality != null) {
          locationName = "${place.subLocality}, $locationName";
        }
        if (place.thoroughfare != null) {
          locationName = "${place.thoroughfare}, $locationName";
        }

        return locationName;
      }
    } catch (e) {
      log('Error getting location name from coordinates: $e');
    }

    return "Unknown";
  }

  Future<String> getNearbyPOIName(double latitude, double longitude) async {
    try {
      Uri uri =
          Uri.https("maps.googleapis.com", 'maps/api/place/nearbysearch/json', {
        "location": "$latitude,$longitude",
        "radius": "500",
        "key": apiKey,
      });

      String? response = await NetWorkUtility.fetchUrl(uri);
      if (response != null) {
        Map<String, dynamic> result = json.decode(response);
        if (result.containsKey("results") &&
            result["results"].isNotEmpty &&
            result["results"][0].containsKey("name")) {
          return result["results"][0]["name"];
        }
      }
    } catch (e) {
      log('Error getting nearby POI name: $e');
    }

    return "Unknown";
  }

  Future<void> handleLocationSelection(String selectedLocation) async {
    try {
      log('Handle Location Selection: $selectedLocation');

      if (selectedLocation == "Use My Current Location") {
        log('Fetching current location...');
        await fetchCurrentLocation();
      } else {
        log('Selected Location: $selectedLocation');

        Position? selectedPosition = await getLatLngFromPlace(selectedLocation);
        if (selectedPosition != null) {
          log('Current Location: Latitude - ${selectedPosition.latitude}, Longitude - ${selectedPosition.longitude}, Location Name - $selectedLocation');
          GigDetailsController gigDetailsController =
              Get.find<GigDetailsController>();
          gigDetailsController.setSelectedLocation(selectedLocation);
          gigDetailsController.setSelectedLatitude(selectedPosition.latitude);
          gigDetailsController.setSelectedLongitude(selectedPosition.longitude);

          Get.to(() => GigDetailsPage(
                selectedLocation: selectedLocation,
                selectedLatitude: selectedPosition.latitude,
                selectedLongitude: selectedPosition.longitude,
              ));
        } else {
          log('Error getting latitude and longitude for selected location');
        }
      }
    } catch (e) {
      log('Error handling location selection: $e');
    }
  }

  Future<Position?> getLatLngFromPlace(String place) async {
    try {
      Uri uri = Uri.https("maps.googleapis.com", 'maps/api/geocode/json', {
        "address": place,
        "key": apiKey,
      });

      String? response = await NetWorkUtility.fetchUrl(uri);
      if (response != null) {
        Map<String, dynamic> result = json.decode(response);
        if (result.containsKey("results") &&
            result["results"].isNotEmpty &&
            result["results"][0].containsKey("geometry") &&
            result["results"][0]["geometry"].containsKey("location")) {
          double latitude = result["results"][0]["geometry"]["location"]["lat"];
          double longitude =
              result["results"][0]["geometry"]["location"]["lng"];

          log("Selected location Coordinates in location picker: Latitude: $latitude // Longitude: $longitude");

          return Position(
            latitude: latitude,
            longitude: longitude,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0,
          );
        }
      }
    } catch (e) {
      log('Error getting latitude and longitude for place: $e');
    }
    return null;
  }
}
