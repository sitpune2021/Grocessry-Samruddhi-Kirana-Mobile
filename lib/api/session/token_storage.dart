import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _key = 'auth_token';
  static const _userKey = 'auth_user';

  static final _storage = FlutterSecureStorage();

  static String? _token;

  // ---------- TOKEN ----------
  static String? get token {
    debugPrint(
      '🔍 Getting token: ${_token != null ? "EXISTS (${_token!.substring(0, 10)}...)" : "NULL"}',
    );
    return _token;
  }

  /// Load token at app start
  static Future<void> init() async {
    debugPrint('🚀 TokenStorage.init() - Starting...');
    try {
      _token = await _storage.read(key: _key);

      if (_token == null) {
        debugPrint('❌ No token found in secure storage');
      } else {
        debugPrint('✅ Token loaded successfully from secure storage');
        debugPrint(
          '🔐 Token (first 20 chars): ${_token!.substring(0, _token!.length > 20 ? 20 : _token!.length)}...',
        );
      }
    } catch (e) {
      debugPrint('⚠️ Error loading token: $e');
    }
  }

  /// Save token
  static Future<void> setToken(String token) async {
    debugPrint('💾 Saving token to secure storage...');
    debugPrint(
      '🔐 Token (first 20 chars): ${token.substring(0, token.length > 20 ? 20 : token.length)}...',
    );

    try {
      _token = token;
      await _storage.write(key: _key, value: token);
      debugPrint('✅ Token stored successfully');

      // Verify it was saved
      final verify = await _storage.read(key: _key);
      if (verify == token) {
        debugPrint('✅ Token verified in storage');
      } else {
        debugPrint('❌ Token verification FAILED!');
      }
    } catch (e) {
      debugPrint('⚠️ Error saving token: $e');
    }
  }

  /// Clear token (logout / expired)
  static Future<void> clear() async {
    debugPrint('🗑️ Clearing token from storage...');
    _token = null;
    await _storage.delete(key: _key);
    await _storage.delete(key: _userKey);
    debugPrint('✅ Token cleared');
  }

  // static bool get isLoggedIn => _token != null && _token!.isNotEmpty;
  static bool get isLoggedIn {
    final loggedIn = _token != null && _token!.isNotEmpty;
    debugPrint('🔐 isLoggedIn check: $loggedIn');
    return loggedIn;
  }

  static Future<void> setUser(String userJson) async {
    await _storage.write(key: _userKey, value: userJson);
  }

  static Future<String?> getUserAsync() async {
    return await _storage.read(key: _userKey);
  }
}
