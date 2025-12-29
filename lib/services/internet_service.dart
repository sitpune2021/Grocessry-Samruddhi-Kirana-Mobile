import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetService {
  static final InternetConnection _checker = InternetConnection.createInstance(
    checkInterval: const Duration(seconds: 3),
  );

  // // 🔹 Cached internet status
  // static bool _lastStatus = true;

  // 🔹 Cached internet status
  static bool _lastStatus = false; // safer default

  /// 🔹 Initialize listener ONCE
  static void initListener() {
    _checker.onStatusChange.listen((status) {
      _lastStatus = status == InternetStatus.connected;
    });
  }

  /// 🔹 Fast access (no async)
  static bool get lastStatus => _lastStatus;

  /// One-time check
  static Future<bool> hasInternet() async {
    return await _checker.hasInternetAccess;
  }

  /// Continuous listener
  static Stream<bool> connectionStream() {
    return _checker.onStatusChange.map(
      (status) => status == InternetStatus.connected,
    );
  }
}
