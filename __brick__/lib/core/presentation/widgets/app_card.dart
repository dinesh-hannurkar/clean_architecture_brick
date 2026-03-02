import 'package:flutter/material.dart';
import 'package:{{project_name}}/core/presentation/theme/app_colors.dart';
import 'package:{{project_name}}/core/presentation/theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 12.0,
    this.elevation = 2.0,
    this.backgroundColor = Colors.white,
    this.borderSide = BorderSide.none,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double elevation;
  final Color backgroundColor;
  final BorderSide borderSide;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(
      padding: padding ?? EdgeInsets.zero,
      child: child,
    );

    return Card(
      margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.xxs),
      elevation: elevation,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: borderSide,
      ),
      clipBehavior: Clip.hardEdge,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: cardContent,
            )
          : cardContent,
    );
  }
}
