import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/course.dart';
import 'dashboard_controller.dart';

class AddEditController extends GetxController {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final lessonsCtrl = TextEditingController();

  final saving = false.obs;
  final selectedCategory = RxnString();

  Course? original;
  int? index;

  late final DashboardController dashboard;

  void init(Course? course, int? idx) {
    if (Get.isRegistered<DashboardController>()) {
      dashboard = Get.find<DashboardController>();
    } else {
      // ensure controller exists so we can access categories and methods
      dashboard = Get.put(DashboardController());
    }
    original = course;
    index = idx;
    if (course != null) {
      titleCtrl.text = course.title;
      descCtrl.text = course.description;
      lessonsCtrl.text = course.lessons.toString();
      selectedCategory.value = course.category;
    } else {
      selectedCategory.value = dashboard.categories.isNotEmpty ? dashboard.categories.first : null;
    }
  }

  Future<void> save() async {
    if (saving.value) return;
    saving.value = true;

    try {
      if (titleCtrl.text.trim().isEmpty) {
        saving.value = false;
        Get.snackbar("Error", "Please enter title");
        return;
      }

      if (lessonsCtrl.text.trim().isEmpty ||
          int.tryParse(lessonsCtrl.text.trim()) == null) {
        saving.value = false;
        Get.snackbar("Error", "Enter a valid number of lessons");
        return;
      }

      final title = titleCtrl.text.trim();
      final desc = descCtrl.text.trim();
      final lessons = int.tryParse(lessonsCtrl.text.trim()) ?? 0;
      final category = selectedCategory.value ??
          (dashboard.categories.isNotEmpty
              ? dashboard.categories.first
              : 'Uncategorized');

      final course = Course(
        id: original?.id,
        title: title,
        description: desc,
        category: category,
        lessons: lessons,
        score: title.length * lessons,
      );

      if (index != null) {
        await dashboard.updateCourse(index!, course);
        await dashboard.loadCourses();
        Get.snackbar("Success", "Course updated successfully");
      } else {
        await dashboard.addCourse(course);
        await dashboard.loadCourses();
        Get.snackbar("Success", "Course added successfully");
      }

      Get.back();

    } catch (e) {
      debugPrint("Error saving course: $e");
      Get.snackbar("Error", "Failed to save course. Try again.");
    } finally {
      saving.value = false;
    }
  }


  @override
  void onClose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    lessonsCtrl.dispose();
    super.onClose();
  }
}
