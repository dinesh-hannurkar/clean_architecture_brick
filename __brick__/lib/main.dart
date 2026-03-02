import 'package:flutter/material.dart';
import 'package:{{project_name}}/core/data/network/injection.dart';
import 'package:{{project_name}}/core/presentation/navigation/app_router.dart';
import 'package:{{project_name}}/core/presentation/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router;

    return MaterialApp.router(
      title: '{{app_display_name}}',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
