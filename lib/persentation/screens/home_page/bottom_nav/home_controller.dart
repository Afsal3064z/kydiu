import 'package:get/get.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;

  void onItemTapped(int index) {
    // ignore: avoid_print
    print('Selected index changed to: $index');
    selectedIndex.value = index;
  }
}