import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract interface for checking network connectivity.
abstract class NetworkInfo {
  /// Checks if the device is currently connected to a network.
  Future<bool> get isConnected;

  /// Stream of connectivity changes.
  Stream<bool> get onConnectivityChanged;
}

/// Implementation of [NetworkInfo] for production use.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _hasInternet(result);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasInternet);
  }

  bool _hasInternet(List<ConnectivityResult> results) {
    return results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn,
    );
  }
}
