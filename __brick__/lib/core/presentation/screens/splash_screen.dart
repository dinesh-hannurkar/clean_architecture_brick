import 'package:flutter/material.dart';
import 'package:{{project_name}}/core/presentation/theme/app_colors.dart';

/// Splash screen shown while the app initializes.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo placeholder — replace with your actual logo
            const Icon(
              Icons.rocket_launch_rounded,
              size: 72,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              '{{app_display_name}}',
              style: textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Loading...',
              style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
