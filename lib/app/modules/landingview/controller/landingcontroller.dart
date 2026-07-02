
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../mentor/controller/mentor_controller.dart';

enum VetLandingItem { home, colleges, saved, updates, profile }

class LandingController extends GetxController {
  static LandingController get to =>
      Get.isRegistered<LandingController>()
          ? Get.find()
          : Get.put(LandingController());

  final currentIndex = 0.obs;

  // Bottom-nav index used by MentorScreen in LandingView's Stack/Offstage.
  static const int _mentorTabIndex = 3;

  VetLandingItem get selectedPage => VetLandingItem.values[currentIndex.value];

  void changePage(int index) {
    currentIndex.value = index;
    _refreshMentorIfNeeded(index);
  }

  void onNavTap(int index) {
    // ✅ Refresh Mentor videos every time this tab is tapped — even if the
    // user is already on it — so newly updated videos show up immediately.
    _refreshMentorIfNeeded(index);

    if (currentIndex.value == index) return;
    currentIndex.value = index;
  }

  void _refreshMentorIfNeeded(int index) {
    if (index == _mentorTabIndex && Get.isRegistered<MentorController>()) {
      Get.find<MentorController>().fetchVideos();
    }
  }

  void onBackPressed() {
    print("BACK PRESSED - index is ${currentIndex.value}");
    if (currentIndex.value != 0) {
      currentIndex.value = 0;
    } else {
      print("TRYING TO EXIT APP");
      SystemNavigator.pop();
    }
  }
  }
