import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/network/api_constants.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/affiliated_collegemodel.dart';
import '../../../no internetconnection/network_service.dart';
import 'enquirycontroller.dart'; // ✅ new — to read registeredCollegeType

class FiliteredCollegescontroller extends GetxController {
  final Dio _dio = Dio();

  final RxList<AffiliatedCollegeModel> colleges          = <AffiliatedCollegeModel>[].obs;
  final RxList<AffiliatedCollegeModel> displayedColleges = <AffiliatedCollegeModel>[].obs;
  final RxList<String>       states            = <String>[].obs;
  final RxString             selectedState     = 'All States'.obs;
  final RxBool               isLoading         = false.obs;
  final RxString             error             = ''.obs;
  final RxString             emptyMessage      = ''.obs;

  String _currentType = '';

  bool _reconnectRegistered = false;

  List<AffiliatedCollegeModel> _platformVisible(List<AffiliatedCollegeModel> list) {
    if (Platform.isIOS) {
      final registeredType = Get.find<EnquiryController>().registeredCollegeType;
      if (registeredType == '1') return [];
    }
    return list;
  }

  Future<void> init(String type) async {
    _currentType = type;
    await Future.wait([
      fetchColleges(type),
      fetchStates(),
    ]);

    await _reapplyStateFilter();

    if (!_reconnectRegistered) {
      Get.find<NetworkService>().register(_onReconnect);
      _reconnectRegistered = true;
    }
  }

  @override
  void onClose() {
    if (_reconnectRegistered) {
      Get.find<NetworkService>().unregister(_onReconnect);
      _reconnectRegistered = false;
    }
    super.onClose();
  }

  Future<void> _onReconnect() async {
    if (_currentType.isEmpty) return;
    await Future.wait([
      fetchColleges(_currentType),
      fetchStates(),
    ]);
    await _reapplyStateFilter();
  }

  Future<void> _reapplyStateFilter() async {
    if (selectedState.value != 'All States') {
      await fetchByState(selectedState.value);
    }
  }

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
        final apiResponse = AffiliatedCollegeListResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        colleges.value          = _platformVisible(apiResponse.data); // ✅
        displayedColleges.value = List.from(colleges);                // ✅ derive from filtered colleges
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

  Future<void> fetchStates() async {
    try {
      final endpoint = _currentType == 'temporary'
          ? '${ApiConstants.baseUrl}/college-states/temporary'
          : '${ApiConstants.baseUrl}/get-college-states';

      final response = await _dio.get(endpoint);
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

  Future<void> fetchByState(String state) async {
    if (state == 'All States') {
      selectedState.value     = 'All States';
      displayedColleges.value = List.from(colleges); // already platform-filtered
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
        final apiResponse = AffiliatedCollegeListResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        displayedColleges.value = _platformVisible(apiResponse.data); // ✅
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

  void clearStateFilter(String type) {
    selectedState.value     = 'All States';
    displayedColleges.value = List.from(colleges);
    emptyMessage.value      = '';
  }
}