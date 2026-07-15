import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../notification_services.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/storage/fcm _token storage.dart';
import '../../../data/errors/ApiErrotHandler.dart';

class PushNotificationController extends GetxController {
  static PushNotificationController get instance =>
      Get.find<PushNotificationController>();

  static const String _apiUrl =
      '${ApiConstants.baseUrl}/device-token';

  static const int _maxRetries = 4;
  static const Duration _retryDelay = Duration(seconds: 2);

  final RxBool isRegistering = false.obs;
  final RxBool isRegistered = false.obs;

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  /// Call this from HomeScreen (e.g. in initState) once the app has
  /// launched into the home screen.
  Future<void> registerDeviceToken() async {
    if (isRegistering.value || isRegistered.value) return;

    isRegistering.value = true;
    try {
      final fcmToken = await _getTokenWithRetry();

      if (fcmToken == null || fcmToken.isEmpty) {
        debugPrint(
            '⚠️ PushNotificationController: no FCM token available, skipping registration.');
        return;
      }

      final deviceData = await _collectDeviceData();

      final body = {
        "fcm_token": fcmToken,
        "app_version": deviceData['app_version'],
        "model": deviceData['model'],
        "model_name": deviceData['model_name'],
        "model_version": deviceData['model_version'],
      };

      debugPrint('📡 Registering device token: $body');

      final response = await _dio.post(_apiUrl, data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = response.data; // dio auto-decodes JSON
        isRegistered.value = decoded is Map && decoded['status'] == true;
        debugPrint('✅ Device token registered: ${response.data}');
      } else {
        debugPrint(
            '❌ Device token registration failed (${response.statusCode}): ${response.data}');
      }
    } on DioException catch (e) {
      // Use ApiErrorHandler just to extract a clean message for logging.
      // This call runs silently in the background, so we deliberately
      // avoid showError() here — we don't want a snackbar or a redirect
      // to the server-error page firing off just because token
      // registration failed.
      final errorMsg = ApiErrorHandler.handleDioError(e);
      debugPrint(
          '⚠️ PushNotificationController Dio error: $errorMsg\n${e.response?.data}');
    } catch (e, st) {
      debugPrint('⚠️ PushNotificationController error: $e\n$st');
    } finally {
      isRegistering.value = false;
    }
  }

  /// Waits for NotificationService to signal that the FCM token is ready
  /// (event-based, no guessing). Falls back to polling FcmTokenStorage
  /// only if that signal times out for some reason.
  Future<String?> _getTokenWithRetry() async {
    // 1) Preferred path: NotificationService tells us the moment it's done.
    try {
      final token = await NotificationService.instance.tokenReady
          .timeout(const Duration(seconds: 20));
      if (token != null && token.isNotEmpty) return token;
    } catch (e) {
      debugPrint('⚠️ tokenReady wait failed/timed out: $e');
    }

    // 2) Fallback: in case tokenReady already completed with null/error
    // before this controller started listening, or storage was written
    // through another path. Short poll as a safety net.
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      final token = await FcmTokenStorage.instance.getFcmToken();
      if (token != null && token.isNotEmpty) return token;
      await Future.delayed(_retryDelay);
    }
    return null;
  }

  Future<Map<String, String>> _collectDeviceData() async {
    String appVersion = 'Unknown';
    String model = 'Unknown';
    String modelName = 'Unknown';
    String modelVersion = 'Unknown';

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;
    } catch (e) {
      debugPrint('⚠️ Could not read app version: $e');
    }

    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        model = androidInfo.model;
        modelName = androidInfo.brand;
        modelVersion = androidInfo.version.release;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        model = iosInfo.utsname.machine;
        modelName = iosInfo.name;
        modelVersion = iosInfo.systemVersion;
      }
    } catch (e) {
      debugPrint('⚠️ Could not read device info: $e');
    }

    return {
      'app_version': appVersion,
      'model': model,
      'model_name': modelName,
      'model_version': modelVersion,
    };
  }
}


