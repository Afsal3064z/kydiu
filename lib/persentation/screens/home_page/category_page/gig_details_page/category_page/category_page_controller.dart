import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CategoryController extends GetxController {
  RxString selectedIconName = "".obs;

  void setIconName(String iconName) {
    selectedIconName.value = iconName;
  }

  @override
  void onClose() {
    // Clear the selectedIconName when the controller is closed (page is disposed)
    selectedIconName.value = "";
    super.onClose();
  }
}
