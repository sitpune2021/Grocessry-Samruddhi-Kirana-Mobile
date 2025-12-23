import 'package:go_router/go_router.dart';
import 'package:samruddha_kirana/screens/dashboard.dart';
import 'package:samruddha_kirana/screens/login_signup_screen.dart';
import 'package:samruddha_kirana/screens/splash_screen.dart';

import 'routes.dart';
import 'page_transition.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        pageBuilder: (context, state) =>
            PageTransitions.slide(state: state, child: const SplashScreen()),
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder: (context, state) =>
            PageTransitions.slide(state: state, child: const LoginScreen()),
      ),
      GoRoute(
        path: Routes.dashboard,
        pageBuilder: (context, state) =>
            PageTransitions.slide(state: state, child: const DashboardScreen()),
      ),
    ],
  );
}
