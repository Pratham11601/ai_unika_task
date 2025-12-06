import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import '../api/api_manager.dart';
import '../models/course.dart';

class CourseRepository {
  CourseRepository._();
  static final GetStorage _storage = GetStorage();
  static const _storageKey = 'courses';

  static Future<List<Course>> loadLocalCourses() async {
    final data = _storage.read<List<dynamic>>(_storageKey);
    if (data == null) return [];
    return data
        .map((e) => Course.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> saveLocalCourses(List<Course> courses) async {
    final list = courses.map((c) => c.toJson()).toList();
    await _storage.write(_storageKey, list);
  }

  static Future<List<Course>> fetchRemoteCourses({bool showLoading = true}) async {
    try {
      var response = await APIManager().getAPICall(
        url: '/Courses',
        showLoading: showLoading,
      );

      return (response as List)
          .map((e) => Course.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("Error fetchRemoteCourses: $e");
      return [];
    }
  }

  static Future<Course?> createCourse(Map<String, dynamic> params) async {
    try {
      final response = await APIManager().postAPICall(
        url: '/Courses',
        params: params,
      );
      return Course.fromJson(response);
    } catch (e) {
      debugPrint("Error createCourse: $e");
      return null;
    }
  }

  static Future<Course?> deleteCourse(String id, Map<String, dynamic> params) async {
    try {
      final response = await APIManager().putAPICall(
        url: '/Courses/$id',
        params: params,
      );
      return Course.fromJson(response);
    } catch (e) {
      debugPrint("Error updateCourse: $e");
      return null;
    }
  }


  static Future<Course?> updateCourse(String id, Map<String, dynamic> params) async {
    try {
      final response = await APIManager().putAPICall(
        url: '/Courses/$id',
        params: params,
      );
      return Course.fromJson(response);
    } catch (e) {
      debugPrint("Error updateCourse: $e");
      return null;
    }
  }

  static Future<bool> deleteRemoteCourse(String id) async {
    try {
      final response = await APIManager().deleteAPICall(
        url: '/Courses/$id',
      );
      return response != null;
    } catch (e) {
      debugPrint('Error deleteRemoteCourse: $e');
      return false;
    }
  }
}
