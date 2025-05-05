import 'package:go_router/go_router.dart';
import 'package:meet_up/data/models/buddy.dart';
import 'package:meet_up/presentation/pages/authentication/login/login_page.dart';
import 'package:meet_up/presentation/pages/authentication/sign_up/sign_up_page.dart';
import 'package:meet_up/presentation/pages/dashboard/chats/chat_details_page.dart';
import 'package:meet_up/presentation/pages/dashboard/chats/chats_page.dart';
import 'package:meet_up/presentation/pages/dashboard/dashboard_page.dart';
import 'package:meet_up/presentation/pages/dashboard/home/home_page.dart';
import 'package:meet_up/presentation/pages/dashboard/settings/settings_page.dart';
import 'package:meet_up/presentation/pages/dashboard/status/status_page.dart';
import 'package:meet_up/presentation/pages/splash/splash_page.dart';

class AppRoutes {
  static const splash = "splash";
  static const login = "login";
  static const signUp = "signUp";
  static const dashboard = "dashboard";
  static const home = "home";
  static const chats = "chats";
  static const chatDetails = "chatDetails";
  static const status = "status";
  static const settings = "settings";

  static const _splash = "/";
  static const _login = "/login";
  static const _signUp = "/signUp";
  static const _dashboard = "/dashboard";
  static const _home = "/home";
  static const _chats = "/chats";
  static const _chatDetails = "/chatDetails";
  static const _status = "/status";
  static const _settings = "/settings";

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

      GoRoute(
        name: chats,
        path: _chats,
        builder: (context, state) => ChatsPage(),
      ),

      GoRoute(
        name: chatDetails,
        path: _chatDetails,
        builder: (context, state) => ChatDetailsPage(buddy: state.extra as Buddy,),
      ),

      GoRoute(
        name: status,
        path: _status,
        builder: (context, state) => StatusPage(),
      ),

      GoRoute(
        name: settings,
        path: _settings,
        builder: (context, state) => SettingsPage(),
      ),
    ],
  );
}
