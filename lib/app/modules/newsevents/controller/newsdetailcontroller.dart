import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/newsdetailmodel.dart';
import '../../../widgets/appsnackbar.dart';


class NewsDetailController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  static const String _endpoint = '/news/details';

  final Rx<NewsDetailModel?> newsDetail = Rx<NewsDetailModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchNewsDetail(String id) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      newsDetail.value = null;

      final response = await _dio.post(
        _endpoint,
        data: {'id': id},
      );

      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        final bool ok = body['status'].toString() == 'true';
        if (ok && body['data'] != null) {
          newsDetail.value =
              NewsDetailModel.fromJson(body['data'] as Map<String, dynamic>);
        } else {
          hasError.value = true;
          errorMessage.value = body['message']?.toString() ?? 'Failed to load news detail';
          AppSnackbar.error(errorMessage.value);
        }
      } else {
        hasError.value = true;
        errorMessage.value = 'Server error (${response.statusCode})';
        AppSnackbar.error(errorMessage.value);
      }
    } on DioException catch (e) {
      hasError.value = true;
      final msg = ApiErrorHandler.handleDioError(e);
      errorMessage.value = msg.isNotEmpty ? msg : 'Something went wrong. Please try again.';

      // Network errors are left to your NetworkAwareWrapper, same as
      // ApiErrorHandler.showError does internally.
      if (!ApiErrorHandler.isNetworkError(e)) {
        ApiErrorHandler.showError(e);
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Something went wrong. Please try again.';
      AppSnackbar.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}