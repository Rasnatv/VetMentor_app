import 'package:get/get.dart';
import '../../Colleges/controller/college_controller.dart';
import '../../Colleges/controller/enquirycontroller.dart';
import '../../courses/controller/courses_controller.dart';
import '../../Colleges/controller/course_detailcontroller.dart';
import '../../Saved/controller/whishlist_controller.dart'; // ← add this

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CollegeController>(() => CollegeController(), fenix: true);
    Get.lazyPut<EnquiryController>(() => EnquiryController(), fenix: true);
    Get.lazyPut<CourseController>(() => CourseController(), fenix: true);
  }
}

class CollegesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CollegeController>(() => CollegeController(), fenix: true);
    Get.lazyPut<EnquiryController>(() => EnquiryController(), fenix: true);
  }
}

// ── CollegeDetailScreen ───────────────────────────────────
class CollegeDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnquiryController>(() => EnquiryController(), fenix: true);
    Get.lazyPut<WishlistController>(() => WishlistController(), fenix: true);
  }
}

// ── CourseDetailScreen ────────────────────────────────────
class CourseDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseDetailController>(() => CourseDetailController(), fenix: true);
  }
}