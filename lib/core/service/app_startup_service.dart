import 'package:shared_preferences/shared_preferences.dart';

enum AppStartState { onboarding, auth, home }

class AppStartupService {
  static const _onboardingKey = 'hasSeenOnboarding';
  static const _loginKey = 'isLoggedIn';

  static Future<AppStartState> getStartState() async {
    final prefs = await SharedPreferences.getInstance();

    final hasSeenOnboarding = prefs.getBool(_onboardingKey) ?? false;
    final isLoggedIn = prefs.getBool(_loginKey) ?? false;

    if (!hasSeenOnboarding) return AppStartState.onboarding;
    if (!isLoggedIn) return AppStartState.auth;
    return AppStartState.home;
  }

  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, value);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, false);
  }
}
