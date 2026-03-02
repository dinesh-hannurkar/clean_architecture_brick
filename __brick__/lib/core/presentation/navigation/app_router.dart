import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name}}/core/presentation/screens/splash_screen.dart';

/// Central application router using GoRouter.
///
/// Add your feature routes inside the `routes` list.
/// Auth redirect logic should be added in the `redirect` callback.
class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      // ── Splash ────────────────────────────────────────────────────────────
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

      // TODO: Add your feature routes below.
      //
      // Example:
      // GoRoute(
      //   path: '/home',
      //   builder: (context, state) => const HomeScreen(),
      // ),
      //
      // GoRoute(
      //   path: '/detail/:id',
      //   builder: (context, state) {
      //     final id = state.pathParameters['id']!;
      //     return DetailScreen(id: id);
      //   },
      // ),
    ],

    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}
