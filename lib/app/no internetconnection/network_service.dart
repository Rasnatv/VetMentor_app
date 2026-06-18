
import 'package:get/get.dart';

/// Holds reconnect callbacks from all controllers.
/// Called by NetworkAwareWrapper when internet comes back.
class NetworkService extends GetxService {
  final List<Future<void> Function()> _callbacks = [];

  void register(Future<void> Function() callback) {
    if (!_callbacks.contains(callback)) {
      _callbacks.add(callback);
    }
  }

  void unregister(Future<void> Function() callback) {
    _callbacks.remove(callback);
  }

  /// Called by NetworkAwareWrapper after reconnect delay
  void onReconnected() {
    for (final cb in List.of(_callbacks)) {
      cb();
    }
  }
}