import 'dart:async';
import 'dart:io';

/// Service for monitoring network connectivity status.
class NetworkInfo {
  NetworkInfo();

  /// Checks if device is currently connected to the internet.
  /// Uses a simple DNS lookup to verify actual internet connectivity.
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Stream of connectivity changes (simplified - checks periodically).
  Stream<bool> get onConnectivityChanged {
    return Stream.periodic(
      const Duration(seconds: 5),
      (_) => isConnected,
    ).asyncMap((connected) => connected);
  }

  /// Waits for internet connection to be restored.
  Future<void> waitForConnection({Duration? timeout}) async {
    final connected = await isConnected;
    if (connected) return;

    final completer = Completer<void>();
    Timer? timer;

    timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (await isConnected) {
        completer.complete();
        timer?.cancel();
      }
    });

    if (timeout != null) {
      return completer.future.timeout(
        timeout,
        onTimeout: () {
          timer?.cancel();
          throw TimeoutException('Network connection timeout');
        },
      );
    }

    return completer.future;
  }

  void dispose() {
    // No resources to dispose in this simplified implementation
  }
}
