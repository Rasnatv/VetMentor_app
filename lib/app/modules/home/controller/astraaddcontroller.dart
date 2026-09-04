import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/network/api_constants.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/astraddmodel.dart';

/// Handles fetching + state for the bottom advertisement banner shown
/// just above the bottom navigation bar. Only ever shows ONE ad at a
/// time (the first item in the list) — that matches the sample banner.
class AdController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  final RxList<AdBannerModel> ads = <AdBannerModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  /// True once the user taps the close (×) button. The banner should
  /// stay hidden for the rest of the session after that.
  final RxBool isDismissed = false.obs;

  /// Single source of truth the UI checks before rendering anything:
  /// only show the banner if we actually have an ad AND the user
  /// hasn't closed it.
  bool get hasAd => ads.isNotEmpty && !isDismissed.value;

  AdBannerModel? get currentAd => ads.isNotEmpty ? ads.first : null;

  @override
  void onInit() {
    super.onInit();
    fetchBottomAds();
  }

  /// NOTE: update this endpoint path to match your actual bottom-ads
  /// route — I used `/bottom-ads` as a placeholder since it wasn't
  /// given. Everything else (parsing, states) will work as-is once the
  /// path is correct.
  Future<void> fetchBottomAds() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await _dio.get('/advertisements');
      final result =
      AdBannerResponse.fromJson(response.data as Map<String, dynamic>);

      if (result.isSuccess) {
        ads.assignAll(result.data);
      } else {
        // API responded but reported failure — treat as "no ad to show"
        // rather than a hard error, since this is a non-critical widget.
        ads.clear();
      }
    } on DioException catch (e) {
      hasError.value = true;
      if (!ApiErrorHandler.isNetworkError(e)) {
        ApiErrorHandler.showError(e);
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  /// Called by the close (×) button on the banner.
  void dismissAd() {
    isDismissed.value = true;
  }
}