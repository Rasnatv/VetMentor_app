
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/network/api_constants.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/coursedetailmodel.dart';
import '../../../no internetconnection/network_service.dart';

class CourseDetailController extends GetxController {
  final Dio _dio = Dio();

  final isLoading                          = false.obs;
  final hasError                           = false.obs;
  final Rx<CourseDetailModel?> courseDetail = Rx<CourseDetailModel?>(null);

  // Keep last courseId for reconnect re-fetch
  String _lastCourseId = '';

  @override
  void onClose() {
    Get.find<NetworkService>().unregister(_onReconnect);
    super.onClose();
  }

  // ── reconnect callback ────────────────────────────────────
  Future<void> _onReconnect() async {
    if (_lastCourseId.isNotEmpty) await fetchCourseDetail(_lastCourseId);
  }

  Future<void> fetchCourseDetail(String courseId) async {
    _lastCourseId = courseId;

    // ✅ Register on first fetch so we have courseId available
    Get.find<NetworkService>().register(_onReconnect);

    isLoading.value = true;
    hasError.value  = false;

    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/course-details',
        data: {'id': courseId},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final json = response.data;

        if (json['status'].toString() == '1') {
          courseDetail.value = CourseDetailModel.fromJson(json['data']);
        } else {
          hasError.value = true;
        }
      } else {
        hasError.value = true;
      }
    } on DioException catch (e) {
      if (ApiErrorHandler.isNetworkError(e)) {
        // ✅ Network error — don't show error widget, NetworkAwareWrapper handles it
        hasError.value = false;
      } else {
        hasError.value = true;
        if (kDebugMode) debugPrint('CourseDetail DioError: ${e.message}');
      }
    } catch (e) {
      hasError.value = true;
      if (kDebugMode) debugPrint('CourseDetail Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}