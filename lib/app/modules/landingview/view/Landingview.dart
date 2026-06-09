import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/bottomnavbar.dart';
import '../../careers/careers_Screen.dart';
import '../../home/view/homescreen.dart';
import '../../Colleges/view/collegescreen.dart';
import '../../Saved/view/SavedScreen.dart';
import '../../mentor/views/mentor.dart';
import '../../profile/view/profilescreen.dart';
import '../controller/landingcontroller.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LandingController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arg = Get.arguments;
      if (arg is int) {
        controller.changePage(arg);
      } else if (arg is VetLandingItem) {
        controller.changePage(arg.index);
      }
    });

    return WillPopScope(
      onWillPop: () async {
        controller.onBackPressed();
        return false;
      },
      child: Obx(
            () => Scaffold(

          bottomNavigationBar: VetBottomNav(
            currentIndex: controller.currentIndex.value,
            onTap: controller.onNavTap,
          ),
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              HomeScreen(),
              CollegesScreen(),
              CareersScreen(),
              MentorScreen (),
              ProfileScreen(),
            ],
          ),
        ),
      ),
    );
  }
}