

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:veterinaryapp/app/core/network/api_constants.dart';
import '../../data/models/coursemodel.dart';

class CourseController extends GetxController {
  final RxList<CourseModel> courses = <CourseModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  final url = '${ApiConstants.baseUrl}/get-courses';

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final res = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      final body = jsonDecode(res.body) as Map<String, dynamic>;

      if (body['status'] == '1') {
        courses.value = (body['data'] as List<dynamic>)
            .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      if (kDebugMode) debugPrint('CourseController error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}