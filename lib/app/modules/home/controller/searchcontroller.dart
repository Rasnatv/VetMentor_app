import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/network/api_constants.dart';
import '../../../data/errors/ApiErrotHandler.dart';

class SearchCollegeModel {
  final int id;
  final String collegeName;
  final String district;
  final String state;
  final  String type;

  const SearchCollegeModel({
    required this.id,
    required this.collegeName,
    required this.district,
    required this.state,
    required this.type,
  });

  factory SearchCollegeModel.fromJson(Map<String, dynamic> json) =>
      SearchCollegeModel(
        id:          json['id'] as int? ?? 0,
        collegeName: json['college_name']?.toString() ?? '',
        district:    json['district']?.toString() ?? '',
        state:       json['state']?.toString() ?? '',
        type:        json['type']?.toString() ?? '0', // ← add this
      );
}

enum SearchState { idle, loading, success, empty, error }

class SearchController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  final RxList<SearchCollegeModel> results   = <SearchCollegeModel>[].obs;
  final Rx<SearchState>            state     = SearchState.idle.obs;
  final RxString                   errorMsg  = ''.obs;
  final RxString                   query     = ''.obs;

  bool get isIdle    => state.value == SearchState.idle;
  bool get isLoading => state.value == SearchState.loading;
  bool get isSuccess => state.value == SearchState.success;
  bool get isEmpty   => state.value == SearchState.empty;
  bool get hasError  => state.value == SearchState.error;

  // Debounce timer
  Worker? _debounce;

  @override
  void onInit() {
    super.onInit();
    // Auto-search whenever query changes (300ms debounce)
    _debounce = debounce(
      query,
          (String q) {
        if (q.trim().length >= 2) {
          search(q.trim());
        } else if (q.trim().isEmpty) {
          _reset();
        }
      },
      time: const Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    _debounce?.dispose();
    super.onClose();
  }

  void onQueryChanged(String value) => query.value = value;

  void _reset() {
    results.clear();
    state.value  = SearchState.idle;
    errorMsg.value = '';
  }

  void clear() {
    query.value = '';
    _reset();
  }

  Future<void> search(String q) async {
    if (q.trim().isEmpty) return;

    state.value    = SearchState.loading;
    errorMsg.value = '';
    results.clear();

    try {
      final res = await _dio.post(
        '/search-colleges',
        data: {'college_name': q.trim()},
      );

      final json = res.data as Map<String, dynamic>;
      final status     = json['status']?.toString() ?? '0';
      final statusCode = json['status_code'] as int? ?? 0;
      final raw        = json['data'];

      if (status == '1' && statusCode == 200 && raw is List) {
        final list = raw
            .whereType<Map<String, dynamic>>()
            .map(SearchCollegeModel.fromJson)
            .toList();

        results.assignAll(list);
        state.value = list.isEmpty ? SearchState.empty : SearchState.success;
      } else {
        state.value    = SearchState.empty;
      }
    } on DioException catch (e) {
      errorMsg.value = ApiErrorHandler.handleDioError(e);
      state.value    = SearchState.error;
    } catch (e) {
      errorMsg.value = e.toString();
      state.value    = SearchState.error;
    }
  }
}