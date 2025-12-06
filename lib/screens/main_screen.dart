import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';
import '../controller/dashboard_controller.dart';

class MainScreen extends GetView<DashboardController> {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const pages = [DashboardScreen(), ProfileScreen()];
    return Obx(() {
      final idx = controller.tabIndex.value;
      return Scaffold(
        body: IndexedStack(index: idx, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: idx,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          onTap: controller.setTabIndex,

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      );
    });
  }
}
