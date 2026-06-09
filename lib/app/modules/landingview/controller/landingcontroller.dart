import 'package:get/get.dart';


enum VetLandingItem { home, colleges, saved, updates, profile }

class LandingController extends GetxController {
  static LandingController get to =>
      Get.isRegistered<LandingController>()
          ? Get.find()
          : Get.put(LandingController());

  final currentIndex = 0.obs;

  VetLandingItem get selectedPage => VetLandingItem.values[currentIndex.value];

  void changePage(int index) {
    currentIndex.value = index;
  }

  void onNavTap(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
  }

  void onBackPressed() {
    if (currentIndex.value != 0) {
      currentIndex.value = 0;
    } else {
      Get.back();
    }
  }
}