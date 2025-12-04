import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:task_round/routes/app_pages.dart';
import 'package:task_round/utils/theme_config.dart';


import 'binding/app_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: "MPlusSoftTask",
          debugShowCheckedModeBanner: false,
          theme: ThemeConfig.lightTheme(),
          initialRoute: AppPages.initialRoute,
          initialBinding: AppBinding(),
          getPages: AppPages.route,
        );
      },
    );
  }
}
