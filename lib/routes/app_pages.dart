import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:task_round/routes/routes.dart';

import '../Screens/dashboard_screen.dart';
import '../Screens/splash_screen.dart';
import '../binding/app_binding.dart';
import '../binding/dashboard_binding.dart';

class AppPages {
  AppPages._();
  static const String initialRoute = Routes.SPLASH_SCREEN;

  static final route = [

    GetPage(
      name: Routes.SPLASH_SCREEN,
      page: () => SplashScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD_SCREEN,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),


  ];
}
