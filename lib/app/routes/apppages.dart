import 'package:get/get.dart';
import '../modules/Colleges/view/allcollegelistingscreen.dart';
import '../modules/Colleges/view/collegedtailscreen.dart';
import '../modules/Splash/view/splashscreen.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/view/homescreen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = MyRoutes.splash;

  static final routes = [
    GetPage(
      name: MyRoutes.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: '/home',
      page: () => HomeScreen(),
      binding: HomeBinding(), // ✅ registers all 3 controllers before page opens
    ),
    GetPage(
      name: '/college-list',
      page: () => CollegeListScreen(),
      binding: CollegesBinding(),
    ),
    GetPage(
      name: '/college-detail',
      page: () => CollegeDetailScreen(collegeId: ''),
      binding: CourseDetailBinding(),
    ),

  ];
}