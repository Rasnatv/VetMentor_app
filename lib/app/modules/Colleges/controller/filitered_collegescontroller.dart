
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../no internetconnection/network_service.dart';

class FiliteredCollegescontroller extends GetxController {
  final Dio _dio = Dio();

  // ── State ─────────────────────────────────────────────────
  final RxList<dynamic> colleges          = <dynamic>[].obs;
  final RxList<dynamic> displayedColleges = <dynamic>[].obs;
  final RxList<String>  states            = <String>[].obs;
  final RxString selectedState            = 'All States'.obs;
  final RxBool   isLoading                = false.obs;
  final RxBool   isSearching              = false.obs;
  final RxString error                    = ''.obs;
  final RxString searchQuery              = ''.obs;

  // Keep track of current type for reconnect
  String _currentType = '';

  Timer? _debounce;

  Future<void> init(String type) async {
    _currentType = type;
    await Future.wait([
      fetchColleges(type),
      fetchStates(),
    ]);
    // ✅ Re-fetch when internet comes back
    Get.find<NetworkService>().register(_onReconnect);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    Get.find<NetworkService>().unregister(_onReconnect);
    super.onClose();
  }

  // ── reconnect callback ────────────────────────────────────
  Future<void> _onReconnect() async {
    if (_currentType.isEmpty) return;
    await Future.wait([
      fetchColleges(_currentType),
      fetchStates(),
    ]);
  }

  // ── Fetch colleges ────────────────────────────────────────
  Future<void> fetchColleges(String type) async {
    isLoading.value = true;
    error.value = '';

    try {
      final endpoint = type == 'temporary'
          ? '${ApiConstants.baseUrl}/temporary-colleges'
          : '${ApiConstants.baseUrl}/permanent-colleges';

      final response = await _dio.get(endpoint);

      if (response.statusCode == 200) {
        final json = response.data;
        colleges.value         = List.from(json['data'] ?? []);
        displayedColleges.value = List.from(colleges);
      } else {
        error.value = 'Server error: ${response.statusCode}';
      }
    } on DioException catch (e) {
      if (ApiErrorHandler.isNetworkError(e)) {
        // ✅ Network error — stay silent, NetworkAwareWrapper handles it
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
        final json = response.data;
        final list = List<String>.from(json['data'] ?? []);
        states.value = ['All States', ...list];
      }
    } on DioException catch (e) {
      // ✅ Silently ignore network errors
      if (!ApiErrorHandler.isNetworkError(e)) {
        // Non-network error — silently fail, states just won't populate
      }
    } catch (_) {}
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        if (selectedState.value == 'All States') {
          displayedColleges.value = List.from(colleges);
        } else {
          fetchByState(selectedState.value);
        }
      } else {
        searchColleges(query.trim());
      }
    });
  }

  Future<void> searchColleges(String name) async {
    isSearching.value = true;

    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/search-colleges',
        data: {'college_name': name},
      );

      if (response.statusCode == 200) {
        final json = response.data;
        displayedColleges.value = List.from(json['data'] ?? []);
      }
    } on DioException catch (e) {
      // ✅ Silently ignore network errors
      if (!ApiErrorHandler.isNetworkError(e)) {
        // Non-network errors — silently fail for search
      }
    } catch (_) {
      // Silently fail
    } finally {
      isSearching.value = false;
    }
  }

  // ── Filter by state ───────────────────────────────────────
  Future<void> fetchByState(String state) async {
    if (state == 'All States') {
      selectedState.value      = 'All States';
      displayedColleges.value = List.from(colleges);
      return;
    }

    selectedState.value = state;
    isLoading.value     = true;

    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/colleges-by-state',
        data: {'state': state},
      );

      if (response.statusCode == 200) {
        final json = response.data;
        displayedColleges.value = List.from(json['data'] ?? []);
      }
    } on DioException catch (e) {
      // ✅ Silently ignore network errors
      if (!ApiErrorHandler.isNetworkError(e)) {
        // Non-network errors — silently fail for filter
      }
    } catch (_) {
      // Silently fail
    } finally {
      isLoading.value = false;
    }
  }

  void clearStateFilter(String type) {
    selectedState.value      = 'All States';
    displayedColleges.value = List.from(colleges);
    if (searchQuery.value.trim().isNotEmpty) {
      searchColleges(searchQuery.value.trim());
    }
  }
}