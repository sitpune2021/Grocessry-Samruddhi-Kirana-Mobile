import 'package:go_router/go_router.dart';
import 'package:samruddha_kirana/screens/auth/sign_up_screen.dart';
import 'package:samruddha_kirana/screens/home/dashboard.dart';
import 'package:samruddha_kirana/screens/auth/sign_in_screen.dart';
import 'package:samruddha_kirana/screens/onboarding/onboarding_screen.dart';
import 'package:samruddha_kirana/screens/splash/splash_screen.dart';
import 'package:samruddha_kirana/widgets/no_internet_view.dart';

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
        path: Routes.noInternet,
        pageBuilder: (context, state) =>
            PageTransitions.slide(state: state, child: const NoInternetView()),
      ),
      GoRoute(
        path: Routes.onboarding,
        pageBuilder: (context, state) => PageTransitions.slide(
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder: (context, state) =>
            PageTransitions.slide(state: state, child: const SignInScreen()),
      ),
      GoRoute(
        path: Routes.signup,
        pageBuilder: (context, state) =>
            PageTransitions.slide(state: state, child: const SignUpScreen()),
      ),
      GoRoute(
        path: Routes.dashboard,
        pageBuilder: (context, state) =>
            PageTransitions.slide(state: state, child: const DashboardScreen()),
      ),
    ],
  );
}
