
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/core/network/api_constants.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/coursemodel.dart';
import '../../../no internetconnection/network_service.dart';

class CourseController extends GetxController {
  final RxList<CourseModel> courses = <CourseModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );
  final _url = '${ApiConstants.baseUrl}/get-courses';

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
    Get.find<NetworkService>().register(_onReconnect);
  }

  @override
  void onClose() {
    Get.find<NetworkService>().unregister(_onReconnect);
    super.onClose();
  }

  Future<void> _onReconnect() => fetchCourses();

  Future<void> fetchCourses() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final res = await _dio.get(_url);
      final body = res.data as Map<String, dynamic>;

      if (body['status'] == '1') {
        courses.value = (body['data'] as List<dynamic>)
            .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
            .toList();
        hasError.value = false;
      } else {
        hasError.value = true;
      }
    } on DioException catch (e) {
      if (ApiErrorHandler.isNetworkError(e)) {
        hasError.value = false;
      } else {
        hasError.value = true;
        ApiErrorHandler.showError(e);
      }
      if (kDebugMode) debugPrint('CourseController DioError: $e');
    } catch (e) {
      hasError.value = true;
      if (kDebugMode) debugPrint('CourseController error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
