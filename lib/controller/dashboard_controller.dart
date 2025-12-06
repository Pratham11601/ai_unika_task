import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/course.dart';
import '../repository/course_repository.dart';
import '../utils/connection.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var courses = <Course>[].obs;
  var filtered = <Course>[].obs;
  var categories = <String>[].obs;
  var searchQuery = ''.obs;
  Rxn<String> selectedCategory = Rxn<String>();
  var tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    everAll([courses, searchQuery, selectedCategory], (_) => _applyFilters());
    loadCourses();
  }

  Future<void> loadCourses() async {
    isLoading.value = true;

    try {
      final local = await CourseRepository.loadLocalCourses();
      if (local.isNotEmpty) {
        courses.assignAll(local);
        _updateCategories();
      }

      final remote = await CourseRepository.fetchRemoteCourses(showLoading: true);
      if (remote.isNotEmpty) {
        courses.assignAll(remote);
        _updateCategories();
        await CourseRepository.saveLocalCourses(remote);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _updateCategories() {
    final set = courses
        .map((e) => e.category)
        .where((c) => c.isNotEmpty)
        .toSet();

    categories.assignAll(set.toList());
  }

  void _applyFilters() {
    final q = searchQuery.value.trim().toLowerCase();

    final output = courses.where((c) {
      final matchesSearch = q.isEmpty ||
          c.title.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q);

      final matchesCategory = selectedCategory.value == null
          ? true
          : c.category == selectedCategory.value;

      return matchesSearch && matchesCategory;
    }).toList();

    filtered.assignAll(output);
  }

  void setSearch(String q) => searchQuery.value = q;

  void setCategory(String? category) {
    selectedCategory.value =
    category == null || category.isEmpty ? null : category;
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedCategory.value = null;
  }

  void setTabIndex(int idx) => tabIndex.value = idx;

  Future<void> addCourse(Course course) async {
    final computedScore = await _computeScore(course.title, course.lessons);
    final local = course.copyWith(
      score: computedScore,
    );

    courses.insert(0, local);
    _updateCategories();
    await CourseRepository.saveLocalCourses(courses);

    final created = await CourseRepository.createCourse(local.toJson());

    if (created != null) {
      final index = courses.indexWhere((c) => c == local);
      if (index != -1) {
        courses[index] = created;
        courses.refresh();
        await CourseRepository.saveLocalCourses(courses);
      }
    }
  }


  Future<void> updateCourse(int index, Course course) async {
    final computedScore = await _computeScore(course.title, course.lessons);
    final local = course.copyWith(
      score: computedScore,
    );

    courses[index] = local;
    courses.refresh();
    await CourseRepository.saveLocalCourses(courses);

    if (local.id != null) {
      final updated = await CourseRepository.updateCourse(
        local.id!,
        local.toJson(),
      );

      if (updated != null) {
        courses[index] = updated;
        courses.refresh();
        await CourseRepository.saveLocalCourses(courses);
      }
    }
  }

  Future<void> deleteCourse(int index) async {
    if (index < 0 || index >= courses.length) return;
    final toDelete = courses[index];

    courses.removeAt(index);
    courses.refresh();
    _updateCategories();
    await CourseRepository.saveLocalCourses(courses);

    if (toDelete.id != null) {
      try {
        await CourseRepository.deleteRemoteCourse(toDelete.id!);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<int> _computeScore(String title, int lessons) async {
    var s = title.length * lessons;
    try {
      final online = await Connection.checkInternet();
      if (!online && s % 2 != 0) {
        s += 1;
      }
    } catch (e) {
      if (s % 2 != 0) s += 1;
    }
    return s;
  }
}
