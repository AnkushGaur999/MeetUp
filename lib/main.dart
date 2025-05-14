import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meet_up/config/routes/app_routes.dart';
import 'package:meet_up/generated/l10n.dart';
import 'package:meet_up/presentation/bloc/account/account_bloc.dart';
import 'package:meet_up/presentation/bloc/auth/auth_bloc.dart';
import 'package:meet_up/presentation/bloc/buddy/buddy_bloc.dart';
import 'package:meet_up/presentation/bloc/chat/chat_bloc.dart';
import 'config/di/service_locator.dart';
import 'core/services/notification_service.dart';
import 'core/utils/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  await NotificationService().initialize();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<BuddyBloc>()),
        BlocProvider(create: (_) => getIt<ChatBloc>()),
        BlocProvider(create: (_) => getIt<AccountBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Meet Up',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: AppRoutes.router,
        supportedLocales: S.delegate.supportedLocales,
        locale: Locale("en"),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
