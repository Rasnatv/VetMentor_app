import 'package:get/get.dart';

import '../controller/eventcontroller.dart';
import '../controller/newscontroller.dart';


class NewsEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsController>(() => NewsController());
    Get.lazyPut<EventController>(() => EventController());
  }
}