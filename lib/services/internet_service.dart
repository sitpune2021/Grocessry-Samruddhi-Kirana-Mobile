import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetService {
  static final InternetConnection _checker = InternetConnection.createInstance(
    checkInterval: const Duration(seconds: 3),
  );

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
