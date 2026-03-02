import 'package:flutter/material.dart';
import 'package:{{project_name}}/core/presentation/theme/app_spacing.dart';

/// A reusable, premium-styled bottom sheet container following the "Blueprint" design language.
class AppBottomSheet extends StatelessWidget {
  /// Creates a [AppBottomSheet].
  const AppBottomSheet({
    required this.title,
    required this.child,
    this.isDraggable = true,
    this.initialChildSize = 0.85,
    this.minChildSize = 0.5,
    this.maxChildSize = 0.95,
    super.key,
  });

  /// The title displayed at the top of the sheet.
  final String title;

  /// The main content of the sheet.
  final Widget child;

  /// Whether the sheet should be scrollable and draggable.
  final bool isDraggable;

  /// The initial height of the sheet (if draggable).
  final double initialChildSize;

  /// The minimum height of the sheet (if draggable).
  final double minChildSize;

  /// The maximum height of the sheet (if draggable).
  final double maxChildSize;

  @override
  Widget build(BuildContext context) {
    if (isDraggable) {
      return DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        builder: _buildContent,
      );
    }
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context, [ScrollController? controller]) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: isDraggable ? MainAxisSize.max : MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Content
          if (isDraggable && controller != null)
            Expanded(
              child: ListView(
                controller: controller,
                padding: EdgeInsets.only(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  bottom: AppSpacing.lg + bottomInset,
                ),
                children: [child],
              ),
            )
          else
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: bottomInset,
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: child,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Helper method to show the [AppBottomSheet].
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  bool isDraggable = true,
  double initialChildSize = 0.85,
  double minChildSize = 0.5,
  double maxChildSize = 0.95,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AppBottomSheet(
      title: title,
      isDraggable: isDraggable,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      child: child,
    ),
  );
}
