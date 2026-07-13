import 'package:get_storage/get_storage.dart';

class FcmTokenStorage {
  FcmTokenStorage._internal();
  static final FcmTokenStorage instance = FcmTokenStorage._internal();

  static const String _containerName = 'fcm_token_box';
  static const String _fcmTokenKey = 'fcm_token';

  final GetStorage _box = GetStorage(_containerName);

  /// Save the FCM token locally. No-op if the token is null/empty.
  Future<void> setFcmToken({required String? fcmToken}) async {
    if (fcmToken == null || fcmToken.isEmpty) return;
    await _box.write(_fcmTokenKey, fcmToken);
  }

  /// Read the last saved FCM token, or null if none has been saved yet.
  /// (Synchronous under the hood since GetStorage caches in memory after
  /// init, but kept as Future<String?> so call sites don't need changes.)
  Future<String?> getFcmToken() async {
    return _box.read<String>(_fcmTokenKey);
  }

  /// Clear the stored token, e.g. on logout, so the next login/app start
  /// forces a fresh registration call with the backend.
  Future<void> clearFcmToken() async {
    await _box.remove(_fcmTokenKey);
  }
}