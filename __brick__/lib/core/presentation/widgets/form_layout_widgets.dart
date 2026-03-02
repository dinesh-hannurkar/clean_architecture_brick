import 'package:flutter/material.dart';
import 'package:{{project_name}}/core/presentation/theme/app_spacing.dart';

/// A layout widget that arranges its [children] in a [Row] with equal width
/// and consistent spacing. Commonly used for form fields.
class AppFormRow extends StatelessWidget {

  const AppFormRow({
    required this.children, super.key,
    this.spacing = AppSpacing.xs,
    this.applyBottomPadding = true,
  });
  final List<Widget> children;
  final double spacing;
  final bool applyBottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: applyBottomPadding ? AppSpacing.xs : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.asMap().entries.map((entry) {
          final isLast = entry.key == children.length - 1;
          final child = entry.value;

          // If child is a Spacer or already Expanded, don't wrap it again
          if (child is Spacer || child is Expanded) {
            return child;
          }

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : spacing),
              child: child,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// A specialized version of [AppFormRow] for a single short field (like Pincode)
/// that should not take the full width of the row.
class AppHalfFieldRow extends StatelessWidget {

  const AppHalfFieldRow({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppFormRow(children: [child, const Spacer()]);
  }
}
