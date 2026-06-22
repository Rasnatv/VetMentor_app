import 'package:get/get.dart';
import '../../Colleges/controller/college_controller.dart';
import '../../Colleges/controller/enquirycontroller.dart';
import '../../courses/controller/courses_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CollegeController>(() => CollegeController());
    Get.lazyPut<EnquiryController>(() => EnquiryController());
    Get.lazyPut<CourseController>(() => CourseController());
  }
}