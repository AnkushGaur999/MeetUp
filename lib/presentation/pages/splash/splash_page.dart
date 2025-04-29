import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/config/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigatePage();
  }

  Future<void> _navigatePage() async {
    Future.delayed(Duration(seconds: 2)).then((value) {
      if (mounted) context.goNamed(AppRoutes.login);
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
