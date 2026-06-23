
import 'package:get/get.dart';

import '../controller/college_controller.dart';
import '../controller/course_detailcontroller.dart';
import '../controller/enquirycontroller.dart';
import '../controller/filitered_collegescontroller.dart';


class CollegesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CollegeController >(
      CollegeController (),
    );
  }
}

class CourseDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CourseDetailController >(
      CourseDetailController  (),
    );
  }
}
class EnquiryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EnquiryController >(
      EnquiryController  (),
    );
  }
}
class FiliteredCollegeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FiliteredCollegescontroller >(
      FiliteredCollegescontroller (),
    );
  }
}



