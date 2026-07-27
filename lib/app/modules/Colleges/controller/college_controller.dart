
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/network/api_constants.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/collegelistmodel.dart';
import '../../../no internetconnection/network_service.dart';

enum CollegeLoadState { initial, loading, success, error }

class CollegeController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  final Rx<CollegeLoadState> loadState = CollegeLoadState.initial.obs;
  final RxList<CollegeModel> colleges = <CollegeModel>[].obs;
  final RxList<CollegeModel> filteredColleges = <CollegeModel>[].obs;
  final RxList<CollegeModel> topColleges = <CollegeModel>[].obs;
  final RxBool topCollegesLoading = false.obs;
  final RxBool topCollegesError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxSet<String> savedIds = <String>{}.obs;

  final RxString collegeType = '0'.obs;

  bool get isLoading => loadState.value == CollegeLoadState.loading;
  bool get hasError => loadState.value == CollegeLoadState.error;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    Get.find<NetworkService>().register(_onReconnect);
    debounce(searchQuery, (_) => _applyFilter(), time: const Duration(milliseconds: 300));
  }

  @override
  void onClose() {
    Get.find<NetworkService>().unregister(_onReconnect);
    super.onClose();
  }

  /// Runs both fetches in PARALLEL instead of sequentially.
  /// Previously this awaited fetchColleges() then fetchTopCollegesFromApi()
  /// one after another — both hitting the SAME endpoint (/college-list),
  /// which meant a slow/unreachable network could stack two timeouts
  /// back to back (up to ~60s) before the home screen could render
  /// anything, leaving the UI stuck on the shimmer loader.
  Future<void> _loadInitialData() async {
    await Future.wait([
      fetchColleges(),
      fetchTopCollegesFromApi(),
    ]);
  }

  Future<void> _onReconnect() async {
    await Future.wait([
      fetchColleges(forceRefresh: true),
      fetchTopCollegesFromApi(),
    ]);
  }

  Future<void> fetchColleges({bool forceRefresh = false}) async {
    loadState.value = CollegeLoadState.loading;
    errorMessage.value = '';

    try {
      final response = await _dio.get('/college-list');
      final result = CollegeListResponse.fromJson(response.data as Map<String, dynamic>);

      if (result.isSuccess) {
        colleges.assignAll(result.data);
        collegeType.value = result.type;
        _applyFilter();
        loadState.value = CollegeLoadState.success;
      } else {
        _handleError(result.message);
      }
    } on DioException catch (e) {
      // FIX: previously a network error left loadState untouched at
      // "initial", which could leave the UI stuck showing nothing
      // useful. Now it always surfaces as an error state so the
      // retry UI can show up instead of an indefinite loading state.
      _handleError(
        ApiErrorHandler.isNetworkError(e)
            ? 'No internet connection. Please try again.'
            : ApiErrorHandler.handleDioError(e),
      );
      if (!ApiErrorHandler.isNetworkError(e)) {
        ApiErrorHandler.showError(e);
      }
    } catch (e) {
      _handleError('Unexpected error occurred.');
    }
  }

  Future<void> fetchTopCollegesFromApi() async {
    topCollegesLoading.value = true;
    topCollegesError.value = false;

    try {
      final response = await _dio.get('/college-list');
      final result = CollegeListResponse.fromJson(response.data as Map<String, dynamic>);

      if (result.isSuccess) {
        topColleges.assignAll(result.data.take(5).toList());
        collegeType.value = result.type;
        topCollegesError.value = false;
      } else {
        topCollegesError.value = true;
        errorMessage.value = result.message;
      }
    } on DioException catch (e) {
      // FIX: previously network errors set topCollegesError = false,
      // which silently hid the failure and could leave the screen
      // showing "No colleges found" instead of a clear retry state.
      // Now ALL failures (network or otherwise) surface as an error.
      topCollegesError.value = true;
      if (!ApiErrorHandler.isNetworkError(e)) {
        ApiErrorHandler.showError(e);
      }
    } catch (e) {
      topCollegesError.value = true;
      errorMessage.value = 'Unexpected error occurred.';
    } finally {
      // Always guaranteed to run — this is what stops the shimmer
      // from spinning forever even if the request above throws.
      topCollegesLoading.value = false;
    }
  }

  void onSearchChanged(String query) => searchQuery.value = query;

  void _applyFilter() {
    final q = searchQuery.value.trim().toLowerCase();
    filteredColleges.assignAll(
      q.isEmpty
          ? colleges
          : colleges.where((c) =>
      c.collegeName.toLowerCase().contains(q) ||
          c.district.toLowerCase().contains(q) ||
          c.state.toLowerCase().contains(q)),
    );
  }

  void _handleError(String msg) {
    errorMessage.value = msg;
    loadState.value = CollegeLoadState.error;
  }
}