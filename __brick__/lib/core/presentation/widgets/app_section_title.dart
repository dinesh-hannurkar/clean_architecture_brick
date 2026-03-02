import 'package:flutter/material.dart';
import 'package:{{project_name}}/core/presentation/theme/app_spacing.dart';

class AppSectionTitle extends StatelessWidget {

  const AppSectionTitle({required this.title, this.margin, super.key});
  final String title;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
