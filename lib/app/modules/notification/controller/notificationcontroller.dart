
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/network/api_constants.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/notificationmodel.dart';
import '../../../widgets/appsnackbar.dart';


class NotificationController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  static const String _endpoint = '/notifications';

  // List of notifications shown on the notification page.
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;

  // Loading / error state for the UI.
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Drives the red dot on the home screen bell icon.
  final RxBool hasUnread = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  /// Number of unread notifications, handy for a badge count instead of just a dot.
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications({bool showLoader = true}) async {
    try {
      if (showLoader) isLoading.value = true;
      errorMessage.value = '';

      final response = await _dio.get(_endpoint);

      if (response.statusCode == 200) {
        // Dio auto-decodes JSON responses into a Map by default, but we
        // guard for the rare case where it comes back as a raw String.
        final dynamic raw = response.data;
        final Map<String, dynamic> decoded = raw is Map<String, dynamic>
            ? raw
            : jsonDecode(raw as String) as Map<String, dynamic>;

        final parsed = NotificationResponse.fromJson(decoded);

        if (parsed.status) {
          // Preserve local read-state for notifications we already had,
          // since the API itself doesn't return a read/unread flag.
          final previouslyRead = {
            for (final n in notifications.where((n) => n.isRead)) n.id: true,
          };

          for (final item in parsed.data) {
            item.isRead = previouslyRead.containsKey(item.id);
          }

          notifications.assignAll(parsed.data);
          _updateHasUnread();
        } else {
          errorMessage.value = parsed.message.isNotEmpty
              ? parsed.message
              : 'Failed to load notifications';
          if (errorMessage.value.isNotEmpty) {
            AppSnackbar.error(errorMessage.value);
          }
        }
      } else {
        errorMessage.value = 'Server error (${response.statusCode})';
        AppSnackbar.error(errorMessage.value);
      }
    } on DioException catch (e) {
      // Network errors (timeout / no connection) are expected to be handled
      // by a NetworkAwareWrapper elsewhere, so we skip showing a snackbar
      // for those and just surface the message in errorMessage.
      final msg = ApiErrorHandler.handleDioError(e);
      errorMessage.value = msg.isNotEmpty ? msg : 'Something went wrong. Please try again.';

    } catch (e) {

    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNotifications() => fetchNotifications(showLoader: false);

  /// Call when the user taps a single notification.
  void markAsRead(NotificationItem item) {
    if (!item.isRead) {
      item.isRead = true;
      notifications.refresh();
      _updateHasUnread();
    }
  }

  /// Call when the notification page is opened, to clear the badge dot.
  void markAllAsRead() {
    for (final n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
    _updateHasUnread();
  }

  void _updateHasUnread() {
    hasUnread.value = notifications.any((n) => !n.isRead);
  }
}