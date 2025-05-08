import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/config/di/service_locator.dart';
import 'package:meet_up/config/routes/app_routes.dart';
import 'package:meet_up/core/local/local_storage_manager.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  late LocalStorageManager storageManager;

  @override
  void initState() {
    super.initState();
    storageManager = getIt<LocalStorageManager>();
    _navigatePage();
  }

  Future<void> _navigatePage() async {
    Future.delayed(Duration(seconds: 2)).then((value) {
      if (mounted) {
        if (storageManager.isLoggedIn()) {
          context.goNamed(AppRoutes.dashboard);
        } else {
          context.goNamed(AppRoutes.login);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/app_icon.png",
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}
