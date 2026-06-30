
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/widgets/appsnackbar.dart';
import '../../../core/network/api_constants.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/whishlistmodel.dart';
import '../../../no internetconnection/network_service.dart';

class WishlistController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  final RxList<WishlistCollege> wishlist  = <WishlistCollege>[].obs;
  final RxSet<String> wishlistedIds       = <String>{}.obs;
  final RxSet<String> loadingIds          = <String>{}.obs;
  final RxBool isFetching                 = false.obs;

  // Keep studentId for reconnect re-fetch
  int _lastStudentId = 0;

  bool isWishlisted(String collegeId) => wishlistedIds.contains(collegeId);
  bool isLoading(String collegeId)    => loadingIds.contains(collegeId);

  @override
  void onClose() {
    Get.find<NetworkService>().unregister(_onReconnect);
    super.onClose();
  }

  // ── reconnect callback ────────────────────────────────────
  Future<void> _onReconnect() async {
    if (_lastStudentId != 0) {
      await fetchWishlist(_lastStudentId, silent: true);
    }
  }

  // ── Fetch ─────────────────────────────────────────────────
  Future<void> fetchWishlist(int studentId, {bool silent = false}) async {
    _lastStudentId = studentId;

    // ✅ Register on first fetch so we have studentId available
    Get.find<NetworkService>().register(_onReconnect);

    if (!silent) isFetching.value = true;

    try {
      final res  = await _dio.post('/get-wishlist', data: {'student_id': studentId});
      final body = res.data as Map<String, dynamic>;

      if (body['status'] == '1' && body['data'] is List) {
        final items = (body['data'] as List)
            .map((e) => WishlistCollege.fromJson(e as Map<String, dynamic>))
            .toList();
        wishlist.assignAll(items);
        wishlistedIds.assignAll(items.map((e) => e.collegeId).toSet());
      } else {
        if (!silent) {
          AppSnackbar.error(
              body['message']?.toString() ?? 'Failed to load wishlist.');
        }
      }
    } on DioException catch (e) {
      if (!silent && !ApiErrorHandler.isNetworkError(e)) {
        AppSnackbar.error(ApiErrorHandler.handleDioError(e));
      }
    } finally {
      if (!silent) isFetching.value = false;
    }
  }

  // ── Add ───────────────────────────────────────────────────
  Future<bool> addToWishlist(int studentId, String collegeId) async {
    if (loadingIds.contains(collegeId)) return false;
    loadingIds.add(collegeId);

    try {
      final res  = await _dio.post('/add-wishlist',
          data: {'student_id': studentId, 'college_id': collegeId});
      final body = res.data as Map<String, dynamic>;

      if (body['status'] == '1') {
        wishlistedIds.add(collegeId);
        await fetchWishlist(studentId);
        return true;
      } else {
        AppSnackbar.error(
            body['message']?.toString() ?? 'Failed to add to wishlist.');
        return false;
      }
    } on DioException catch (e) {
      if (!ApiErrorHandler.isNetworkError(e)) {
        // ✅ Only show snackbar for non-network errors
        AppSnackbar.error(ApiErrorHandler.handleDioError(e));
      }
      return false;
    } finally {
      loadingIds.remove(collegeId);
    }
  }

  // ── Remove ────────────────────────────────────────────────
  Future<bool> removeFromWishlist(int studentId, String collegeId) async {
    if (loadingIds.contains(collegeId)) return false;
    loadingIds.add(collegeId);

    try {
      final res  = await _dio.put('/remove-wishlist',
          data: {'student_id': studentId, 'college_id': collegeId});
      final body = res.data as Map<String, dynamic>;

      if (body['status'] == '1') {
        wishlistedIds.remove(collegeId);
        wishlist.removeWhere((e) => e.collegeId == collegeId);
        return true;
      } else {
        AppSnackbar.error(
            body['message']?.toString() ?? 'Failed to remove from wishlist.');
        return false;
      }
    } on DioException catch (e) {
      if (!ApiErrorHandler.isNetworkError(e)) {
        // ✅ Only show snackbar for non-network errors
        AppSnackbar.error(ApiErrorHandler.handleDioError(e));
      }
      return false;
    } finally {
      loadingIds.remove(collegeId);
    }
  }

  Future<void> toggleWishlist(int studentId, String collegeId) async {
    if (isWishlisted(collegeId)) {
      await removeFromWishlist(studentId, collegeId);
    } else {
      await addToWishlist(studentId, collegeId);
    }
  }
}