
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/network/api_constants.dart';
import '../../../data/models/coursedetailmodel.dart';

class CourseDetailController extends GetxController {
  final isLoading = false.obs;
  final hasError = false.obs;
  final Rx<CourseDetailModel?> courseDetail = Rx<CourseDetailModel?>(null);

  Future<void> fetchCourseDetail(String courseId) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/course-details'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': courseId,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == '1') {
          courseDetail.value = CourseDetailModel.fromJson(json['data']);
        } else {
          hasError.value = true;
        }
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      print('Course Detail Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}