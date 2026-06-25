import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/collegelistmodel.dart';
import '../../../no internetconnection/network_service.dart';

class FiliteredCollegescontroller extends GetxController {
  final Dio _dio = Dio();

  // ── State ─────────────────────────────────────────────────
  final RxList<CollegeModel> colleges          = <CollegeModel>[].obs;
  final RxList<CollegeModel> displayedColleges = <CollegeModel>[].obs;
  final RxList<String>       states            = <String>[].obs;
  final RxString             selectedState     = 'All States'.obs;
  final RxBool               isLoading         = false.obs;
  final RxString             error             = ''.obs;
  final RxString             emptyMessage      = ''.obs;

  String _currentType = '';

  // ── Init ──────────────────────────────────────────────────
  Future<void> init(String type) async {
    _currentType = type;
    await Future.wait([
      fetchColleges(type),
      fetchStates(),
    ]);
    Get.find<NetworkService>().register(_onReconnect);
  }

  @override
  void onClose() {
    Get.find<NetworkService>().unregister(_onReconnect);
    super.onClose();
  }

  Future<void> _onReconnect() async {
    if (_currentType.isEmpty) return;
    await Future.wait([
      fetchColleges(_currentType),
      fetchStates(),
    ]);
  }

  // ── Fetch all colleges ────────────────────────────────────
  Future<void> fetchColleges(String type) async {
    isLoading.value    = true;
    error.value        = '';
    emptyMessage.value = '';

    try {
      final endpoint = type == 'temporary'
          ? '${ApiConstants.baseUrl}/temporary-colleges'
          : '${ApiConstants.baseUrl}/permanent-colleges';

      final response = await _dio.get(endpoint);

      if (response.statusCode == 200) {
        final apiResponse = CollegeListResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        colleges.value          = apiResponse.data;
        displayedColleges.value = List.from(apiResponse.data);
      } else {
        error.value = 'Server error: ${response.statusCode}';
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final body = e.response?.data;
        colleges.value          = [];
        displayedColleges.value = [];
        emptyMessage.value = (body is Map && body['message'] != null)
            ? body['message'].toString()
            : 'No colleges found';
      } else if (ApiErrorHandler.isNetworkError(e)) {
        error.value = '';
      } else {
        error.value = ApiErrorHandler.handleDioError(e);
      }
    } catch (e) {
      error.value = 'Failed to load. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Fetch states ──────────────────────────────────────────
  Future<void> fetchStates() async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/get-college-states',
      );
      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        final list = List<String>.from(json['data'] ?? []);
        states.value = ['All States', ...list];
      }
    } on DioException catch (e) {
      if (!ApiErrorHandler.isNetworkError(e)) {
        // Non-network error — silently fail
      }
    } catch (_) {}
  }

  // ── Filter by state ───────────────────────────────────────
  Future<void> fetchByState(String state) async {
    if (state == 'All States') {
      selectedState.value     = 'All States';
      displayedColleges.value = List.from(colleges);
      emptyMessage.value      = '';
      return;
    }

    selectedState.value = state;
    isLoading.value     = true;
    emptyMessage.value  = '';

    try {
      final endpoint = _currentType == 'permanent'
          ? '${ApiConstants.baseUrl}/colleges/permanent'
          : '${ApiConstants.baseUrl}/colleges-by-state';

      final response = await _dio.post(
        endpoint,
        data: {'state': state},
      );

      if (response.statusCode == 200) {
        final apiResponse = CollegeListResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        displayedColleges.value = apiResponse.data;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final body = e.response?.data;
        displayedColleges.value = [];
        emptyMessage.value = (body is Map && body['message'] != null)
            ? body['message'].toString()
            : 'No colleges found for this state';
      } else if (!ApiErrorHandler.isNetworkError(e)) {
        // Non-network errors — silently fail
      }
    } catch (_) {}
    finally {
      isLoading.value = false;
    }
  }

  // ── Clear filter ──────────────────────────────────────────
  void clearStateFilter(String type) {
    selectedState.value     = 'All States';
    displayedColleges.value = List.from(colleges);
    emptyMessage.value      = '';
  }
}