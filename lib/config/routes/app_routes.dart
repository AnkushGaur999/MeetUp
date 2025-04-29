import 'package:go_router/go_router.dart';
import 'package:meet_up/presentation/pages/authentication/login/login_page.dart';
import 'package:meet_up/presentation/pages/authentication/sign_up/sign_up_page.dart';
import 'package:meet_up/presentation/pages/dashboard/dashboard_page.dart';
import 'package:meet_up/presentation/pages/dashboard/home/home_page.dart';
import 'package:meet_up/presentation/pages/splash/splash_page.dart';

class AppRoutes {
  static const splash = "splash";
  static const login = "login";
  static const signUp = "signUp";
  static const dashboard = "dashboard";
  static const home = "home";

  static const _splash = "/";
  static const _login = "/login";
  static const _signUp = "/signUp";
  static const _dashboard = "/dashboard";
  static const _home = "/home";

  static final router = GoRouter(
    initialLocation: _splash,
    routes: [
      GoRoute(
        name: splash,
        path: _splash,
        builder: (context, state) => SplashPage(),
      ),
      GoRoute(
        name: login,
        path: _login,
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        name: signUp,
        path: _signUp,
        builder: (context, state) => SignUpPage(),
      ),

      GoRoute(
        name: dashboard,
        path: _dashboard,
        builder: (context, state) => DashboardPage(),
      ),
      GoRoute(name: home, path: _home, builder: (context, state) => HomePage()),
    ],
  );
}
