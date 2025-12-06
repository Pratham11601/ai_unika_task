import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../widgets/constant_widgets.dart';
import '../controller/dashboard_controller.dart';

class ProfileScreen extends GetView<DashboardController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const name = 'John Doe';
    const age = 28;

    return Obx(() {
      final points = controller.courses.fold<int>(0, (sum, c) => sum + c.score);
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 24.4.w,
                        height: 24.4.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person, size: 48, color: Theme.of(context).colorScheme.primary),
                      ),
                      width(4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            height(0.8.h),
                            Text('Age: $age', style: Theme.of(context).textTheme.bodyMedium),
                            height(1.h),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, size: 16, color: Colors.amber),
                                      width(1.w),
                                      Text('$points points', style: Theme.of(context).textTheme.bodyMedium),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              height(3.h),
            ],
          ),
        ),
      );
    });
  }
}
