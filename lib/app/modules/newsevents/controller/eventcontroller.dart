import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/eventmodel.dart';
import '../../../widgets/appsnackbar.dart';


class EventController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  static const String _endpoint = '/events';

  final RxList<EventModel> eventList = <EventModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await _dio.get(_endpoint);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data as Map<String, dynamic>;
        final List data = body['data'] ?? [];
        eventList.value = data.map((e) => EventModel.fromJson(e)).toList();
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

  Future<void> refreshEvents() => fetchEvents();
}