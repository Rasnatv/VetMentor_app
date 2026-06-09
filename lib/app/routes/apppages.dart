import 'package:get/get.dart';

import '../modules/Splash/view/splashscreen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = MyRoutes.splash;

  static final routes = [
    GetPage(
      name: MyRoutes.splash,
      page: () => SplashScreen(),
    ),
  ];
}