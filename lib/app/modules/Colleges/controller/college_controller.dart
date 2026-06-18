
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/storage/storage.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/collegelistmodel.dart';
import '../../../no internetconnection/network_service.dart';

enum CollegeLoadState { initial, loading, success, error }

const _kCollegeListCache = 'college_list_cache';
const _kSavedCollegeIds = 'saved_college_ids';

class CollegeController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
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

  bool get isLoading => loadState.value == CollegeLoadState.loading;
  bool get hasError => loadState.value == CollegeLoadState.error;

  @override
  void onInit() {
    super.onInit();
    _loadSavedIds();
    fetchColleges();
    fetchTopCollegesFromApi();
    Get.find<NetworkService>().register(_onReconnect);
    debounce(searchQuery, (_) => _applyFilter(),
        time: const Duration(milliseconds: 300));
  }

  @override
  void onClose() {
    Get.find<NetworkService>().unregister(_onReconnect);
    super.onClose();
  }

  Future<void> _onReconnect() async {
    await fetchColleges(forceRefresh: true);
    await fetchTopCollegesFromApi();
  }

  Future<void> fetchColleges({bool forceRefresh = false}) async {
    if (!forceRefresh && _loadFromCache()) return;

    loadState.value = CollegeLoadState.loading;
    errorMessage.value = '';

    try {
      final response = await _dio.get('/college-list');

      final result = CollegeListResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (result.isSuccess) {
        colleges.assignAll(result.data);
        _applyFilter();
        _saveToCache(result.data);
        loadState.value = CollegeLoadState.success;
      } else {
        _handleError(result.message);
      }
    } on DioException catch (e) {
      if (!_loadFromCache()) {
        if (ApiErrorHandler.isNetworkError(e)) {
          loadState.value = CollegeLoadState.initial;
        } else {
          ApiErrorHandler.showError(e); // ✅ handles 508 + others
          _handleError(ApiErrorHandler.handleDioError(e));
        }
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

      final result = CollegeListResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (result.isSuccess) {
        topColleges.assignAll(result.data.take(5).toList());
        topCollegesError.value = false;
      } else {
        topCollegesError.value = true;
        errorMessage.value = result.message;
      }
    } on DioException catch (e) {
      if (ApiErrorHandler.isNetworkError(e)) {
        topCollegesError.value = false;
      } else {
        topCollegesError.value = true;
        ApiErrorHandler.showError(e); // ✅ handles 508 + others
      }
    } catch (e) {
      topCollegesError.value = true;
      errorMessage.value = 'Unexpected error occurred.';
    } finally {
      topCollegesLoading.value = false;
    }
  }

  void onSearchChanged(String query) => searchQuery.value = query;

  void toggleSave(CollegeModel college) {
    savedIds.contains(college.id)
        ? savedIds.remove(college.id)
        : savedIds.add(college.id);
    _persistSavedIds();
  }

  bool isSaved(CollegeModel college) => savedIds.contains(college.id);

  List<CollegeModel> get savedColleges =>
      colleges.where((c) => savedIds.contains(c.id)).toList();

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

  bool _loadFromCache() {
    final raw = Storage.getValue<String>(_kCollegeListCache);
    if (raw == null || raw.isEmpty) return false;
    try {
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => CollegeModel.fromJson(e as Map<String, dynamic>))
          .toList();
      if (list.isEmpty) return false;
      colleges.assignAll(list);
      _applyFilter();
      loadState.value = CollegeLoadState.success;
      return true;
    } catch (_) {
      return false;
    }
  }

  void _saveToCache(List<CollegeModel> data) => Storage.saveValueForce(
      _kCollegeListCache, jsonEncode(data.map((e) => e.toJson()).toList()));

  void _loadSavedIds() {
    final raw = Storage.getValue<String>(_kSavedCollegeIds);
    if (raw != null && raw.isNotEmpty) {
      try {
        savedIds.addAll(
            (jsonDecode(raw) as List<dynamic>).map((e) => e.toString()));
      } catch (_) {}
    }
  }

  void _persistSavedIds() => Storage.saveValueForce(
      _kSavedCollegeIds, jsonEncode(savedIds.toList()));
}