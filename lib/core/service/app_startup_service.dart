import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:samruddha_kirana/api/session/token_storage.dart';

enum AppStartState { onboarding, auth, home }

class AppStartupService {
  static const _onboardingKey = 'hasSeenOnboarding';

  static Future<AppStartState> getStartState() async {
    debugPrint('📱 AppStartupService - Getting start state...');
    // ✅ Initialize TokenStorage first
    await TokenStorage.init();

    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool(_onboardingKey) ?? false;

    debugPrint('👀 Has seen onboarding: $hasSeenOnboarding');
    debugPrint('🔐 Is logged in: ${TokenStorage.isLoggedIn}');

    // 1️⃣ Onboarding
    if (!hasSeenOnboarding) {
      debugPrint('➡️ Navigating to: ONBOARDING');
      return AppStartState.onboarding;
    }

    // 2️⃣ Logged in
    if (TokenStorage.isLoggedIn) {
      debugPrint('➡️ Navigating to: HOME (User is logged in)');
      return AppStartState.home;
    }

    // 3️⃣ Login
    debugPrint('➡️ Navigating to: AUTH (Login required)');
    return AppStartState.auth;
  }

  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
    debugPrint('✅ Onboarding marked as seen');
  }
}
