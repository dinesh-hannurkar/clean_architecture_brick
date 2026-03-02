import 'package:flutter/material.dart';
import 'package:{{project_name}}/core/presentation/theme/app_spacing.dart';
import 'package:{{project_name}}/core/presentation/theme/app_colors.dart';
import 'package:{{project_name}}/core/presentation/navigation/navigation_service.dart';

/// Global key to access ScaffoldMessenger without context
final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Internal flag to track if connectivity snackbar is active
bool _isConnectivityActive = false;

/// Shows a styled snackbar with customizable color and icon
void showStyledSnackBar(
  BuildContext? context,
  String message, {
  Color? backgroundColor,
  IconData? icon,
  Duration duration = const Duration(seconds: 4),
  bool showCloseButton = true,
  DismissDirection dismissDirection = DismissDirection.down,
  bool isConnectivity = false,
}) {
  // If a connectivity snackbar is active, don't show any other snackbars
  if (_isConnectivityActive && !isConnectivity) return;

  if (isConnectivity) {
    _isConnectivityActive = true;
  }

  final effectiveContext = context ?? NavigationService.context;

  Color? bgColor = backgroundColor;
  if (bgColor == null && effectiveContext != null && effectiveContext.mounted) {
    try {
      bgColor = Theme.of(effectiveContext).colorScheme.surface;
    } catch (_) {
      bgColor = Colors.blueGrey;
    }
  }
  bgColor ??= Colors.blueGrey;

  final snackBar = SnackBar(
    content: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: Colors.white),
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      ],
    ),
    backgroundColor: bgColor,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(AppSpacing.md),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.sm),
    ),
    elevation: 4,
    duration: duration,
    dismissDirection: dismissDirection,
    action: showCloseButton
        ? SnackBarAction(
            label: 'CLOSE',
            textColor: Colors.white,
            onPressed: () {
              messengerKey.currentState?.hideCurrentSnackBar();
            },
          )
        : null,
  );

  messengerKey.currentState?.hideCurrentSnackBar();
  messengerKey.currentState?.showSnackBar(snackBar);
}

/// Shows a persistent connectivity error snackbar
void showConnectivitySnackBar(String message) {
  showErrorSnackBar(
    null,
    message,
    duration: const Duration(days: 365),
    showCloseButton: false,
    dismissDirection: DismissDirection.none,
    isConnectivity: true,
  );
}

/// Hides the connectivity snackbar and unlocks other snackbars
void hideConnectivitySnackBar() {
  _isConnectivityActive = false;
  messengerKey.currentState?.hideCurrentSnackBar();
}

/// Shows an error snackbar (red background)
void showErrorSnackBar(
  BuildContext? context,
  String message, {
  Duration duration = const Duration(seconds: 4),
  bool showCloseButton = true,
  DismissDirection dismissDirection = DismissDirection.down,
  bool isConnectivity = false,
}) {
  final effectiveContext = context ?? NavigationService.context;
  Color? bgColor;

  if (effectiveContext != null && effectiveContext.mounted) {
    try {
      bgColor = Theme.of(effectiveContext).colorScheme.error;
    } catch (_) {}
  }
  bgColor ??= AppColors.error;

  showStyledSnackBar(
    effectiveContext,
    message,
    backgroundColor: bgColor,
    icon: Icons.error_outline,
    duration: duration,
    showCloseButton: showCloseButton,
    dismissDirection: dismissDirection,
    isConnectivity: isConnectivity,
  );
}

/// Shows a success snackbar (green background)
void showSuccessSnackBar(
  BuildContext? context,
  String message, {
  bool showCloseButton = false,
}) {
  showStyledSnackBar(
    context ?? NavigationService.context,
    message,
    backgroundColor: AppColors.success,
    icon: Icons.check_circle_outline,
    showCloseButton: showCloseButton,
    duration: const Duration(seconds: 3),
  );
}

/// Shows an info snackbar (blue background)
void showInfoSnackBar(
  BuildContext? context,
  String message, {
  bool showCloseButton = false,
}) {
  showStyledSnackBar(
    context ?? NavigationService.context,
    message,
    backgroundColor: AppColors.info,
    icon: Icons.info_outline,
    showCloseButton: showCloseButton,
    duration: const Duration(seconds: 3),
  );
}

/// Shows a warning snackbar (orange background)
void showWarningSnackBar(
  BuildContext? context,
  String message, {
  bool showCloseButton = true,
}) {
  showStyledSnackBar(
    context ?? NavigationService.context,
    message,
    backgroundColor: AppColors.warning,
    icon: Icons.warning_amber_outlined,
    showCloseButton: showCloseButton,
  );
}
