//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../widgets/bottomnavbar.dart';
// import '../../careers/careers_Screen.dart';
// import '../../home/view/homescreen.dart';
// import '../../Colleges/view/collegescreen.dart';
// import '../../mentor/views/mentor.dart';
// import '../../profile/view/profilescreen.dart';
// import '../controller/landingcontroller.dart';
//
// class LandingView extends StatelessWidget {
//   const LandingView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(LandingController());
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final arg = Get.arguments;
//       if (arg is int) {
//         controller.changePage(arg);
//       } else if (arg is VetLandingItem) {
//         controller.changePage(arg.index);
//       }
//     });
//
//     return WillPopScope(
//       onWillPop: () async {
//         controller.onBackPressed();
//         return false;
//       },
//       child: Obx(
//             () {
//           final index = controller.currentIndex.value;
//           return Scaffold(
//             bottomNavigationBar: VetBottomNav(
//               currentIndex: index,
//               onTap: controller.onNavTap,
//             ),
//             body: Stack(
//               children: [
//                 // ── These 4 stay alive in IndexedStack ──────
//                 Offstage(
//                   offstage: index != 0,
//                   child: const HomeScreen(),
//                 ),
//                 Offstage(
//                   offstage: index != 1,
//                   child: const AffiliationSelectorScreen(),
//                 ),
//                 Offstage(
//                   offstage: index != 2,
//                   child: const CareersScreen(),
//                 ),
//                 Offstage(
//                   offstage: index != 3,
//                   child: const MentorScreen(),
//                 ),
//                 // ── Profile rebuilds fresh every time ────────
//                  if (index == 4) const ProfileScreen(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/bottomnavbar.dart';
import '../../careers/careers_Screen.dart';
import '../../home/bindings/home_binding.dart';
import '../../home/view/homescreen.dart';
import '../../Colleges/view/collegescreen.dart';
import '../../mentor/views/mentor.dart';
import '../../profile/view/profilescreen.dart';
import '../controller/landingcontroller.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LandingController());

    // ✅ Register all controllers before screens build
    HomeBinding().dependencies();

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
            () {
          final index = controller.currentIndex.value;
          return Scaffold(
            bottomNavigationBar: VetBottomNav(
              currentIndex: index,
              onTap: controller.onNavTap,
            ),
            body: Stack(
              children: [
                Offstage(
                  offstage: index != 0,
                  child: const HomeScreen(),
                ),
                Offstage(
                  offstage: index != 1,
                  child: const AffiliationSelectorScreen(),
                ),
                Offstage(
                  offstage: index != 2,
                  child: const CareersScreen(),
                ),
                Offstage(
                  offstage: index != 3,
                  child: const MentorScreen(),
                ),
                if (index == 4) const ProfileScreen(),
              ],
            ),
          );
        },
      ),
    );
  }
}