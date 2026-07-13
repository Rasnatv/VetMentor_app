
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/network/api_constants.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/comparemodel.dart';


class CompareController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<CompareCollegeModel> colleges = <CompareCollegeModel>[].obs;

  static final String _endpoint = '${ApiConstants.baseUrl}/compare-colleges';

  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    final ids = Get.arguments as List<String>? ?? [];
    if (ids.isNotEmpty) fetchComparison(ids);
  }

  Future<void> fetchComparison(List<String> ids) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final response = await _dio.post(
        _endpoint,
        data: {'college_ids': ids}, // ✅ List<String> sent as-is, Dio handles JSON encoding
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final decoded = response.data;

      if (response.statusCode == 200) {
        if (decoded['status'] == true) {
          final List data = decoded['data'] ?? [];
          colleges.value =
              data.map((e) => CompareCollegeModel.fromJson(e)).toList();
        } else {
          hasError.value = true;
          errorMessage.value = decoded['message'] ?? 'Something went wrong';
        }
      } else {
        hasError.value = true;
        errorMessage.value = 'Server error (${response.statusCode})';
      }
    } on DioException catch (e) {
      hasError.value = true;
      // Reuses your existing ApiErrorHandler so messages/status-code
      // handling (401/404/422/508 etc.) stay consistent app-wide.
      final msg = ApiErrorHandler.handleDioError(e);
      errorMessage.value = msg.isNotEmpty
          ? msg
          : 'Unable to fetch comparison. Check connection.';

      // Optional: also show the snackbar / server-error-page navigation
      // exactly like the rest of the app does. Comment out if you'd
      // rather only surface the error inline via errorMessage.
      ApiErrorHandler.showError(e);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Unable to fetch comparison. Check connection.';
    } finally {
      isLoading.value = false;
    }
  }

  void removeCollege(String id) {
    colleges.removeWhere((c) => c.id == id);
    if (colleges.length < 2) {
      Get.back();
    }
  }
}