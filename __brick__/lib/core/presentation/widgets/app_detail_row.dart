import 'package:flutter/material.dart';

class AppDetailRow extends StatelessWidget {

  const AppDetailRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.dividerColor,
    this.showDivider = false,
    super.key,
  });
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final Color? dividerColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style:
                  labelStyle ??
                  TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style:
                    valueStyle ??
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 14,
                    ),
              ),
            ),
          ],
        ),
        if (showDivider)
          Divider(height: 32, color: dividerColor ?? Colors.grey[200]),
      ],
    );
  }
}
