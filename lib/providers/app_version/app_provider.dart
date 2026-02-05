import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoProvider extends ChangeNotifier {
  String version = '';
  String buildNumber = '';

  String get fullVersion => '$version ($buildNumber)';

  bool _loaded = false;

  Future<void> loadAppInfo() async {
    if (_loaded) return; // 👈 prevents duplicate calls
    _loaded = true;

    try {
      final info = await PackageInfo.fromPlatform();
      version = info.version;
      buildNumber = info.buildNumber;
      notifyListeners();
    } catch (e) {
      debugPrint('PackageInfo error: $e');
    }
  }
}
