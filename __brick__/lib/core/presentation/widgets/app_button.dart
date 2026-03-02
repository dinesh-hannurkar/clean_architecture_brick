import 'package:flutter/material.dart';
import 'package:{{project_name}}/core/presentation/theme/app_colors.dart';
import 'package:{{project_name}}/core/presentation/theme/app_spacing.dart';

/// A premium customized button used across the application.
///
/// Supports loading states, icons, and custom width.
class AppButton extends StatelessWidget {
  /// Creates an [AppButton].
  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  /// The text label for the button.
  final String text;

  /// Callback when the button is pressed. If null, the button is disabled.
  final VoidCallback? onPressed;

  /// Whether to show a loading indicator instead of text/icon.
  final bool isLoading;

  /// Optional icon to display before the text.
  final IconData? icon;

  /// Optional fixed width for the button. Defaults to full width.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: width ?? double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.onPrimary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
