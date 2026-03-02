import 'package:flutter/material.dart';
import 'package:{{project_name}}/core/presentation/theme/app_colors.dart';

/// A custom themed AppBar used throughout the application.
///
/// Provides a consistent gradient background and supports profile actions,
/// custom titles, and optional bottom widgets.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [AppAppBar].
  const AppAppBar({
    super.key,
    this.title,
    this.titleText,
    this.subtitleText,
    this.leading,
    this.actions,
    this.onProfileTap,
    this.bottom,
    this.centerTitle = false,
    this.showBackButton = false,
    this.showProfile = false,
  });

  /// Custom title widget. If provided, [titleText] is ignored.
  final Widget? title;

  /// Simple title text.
  final String? titleText;

  /// Optional subtitle text displayed below the title.
  final String? subtitleText;

  /// Custom leading widget. If null and [showBackButton] is true, shows back arrow.
  final Widget? leading;

  /// List of action widgets to show in the AppBar.
  final List<Widget>? actions;

  /// Callback when the profile icon is tapped.
  final VoidCallback? onProfileTap;

  /// Optional widget displayed at the bottom of the toolbar.
  final PreferredSizeWidget? bottom;

  /// Whether the title should be centered.
  final bool centerTitle;

  /// Whether to show the default back button.
  final bool showBackButton;

  /// Whether to show the user profile button in actions.
  final bool showProfile;

  @override
  Size get preferredSize =>
      Size.fromHeight(56.0 + (bottom?.preferredSize.height ?? 0.0) + 0.0);

  @override
  Widget build(BuildContext context) {
    var effectiveTitle = title;

    if (effectiveTitle == null && titleText != null) {
      effectiveTitle = Column(
        crossAxisAlignment: centerTitle
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            titleText!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (subtitleText != null)
            Text(
              subtitleText!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
        ],
      );
    }

    var effectiveLeading = leading;
    if (effectiveLeading == null && showBackButton) {
      effectiveLeading = IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 56,
            leading: effectiveLeading,
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: centerTitle,
            title:
                effectiveTitle ??
                Row(
                  children: [
                    const SizedBox(width: 4),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 32,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          'app',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
            actions:
                actions ??
                (showProfile
                    ? [
                        IconButton(
                          icon: const Icon(
                            Icons.account_circle,
                            size: 28,
                            color: Colors.white,
                          ),
                          onPressed: onProfileTap ?? () {},
                        ),
                        const SizedBox(width: 4),
                      ]
                    : null),
          ),
          if (bottom != null) bottom!,
        ],
      ),
    );
  }
}
