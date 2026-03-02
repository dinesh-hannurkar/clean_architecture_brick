import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:{{project_name}}/core/presentation/navigation/navigation_service.dart';
import 'package:{{project_name}}/core/presentation/utils/snackbar_utils.dart';

/// Utility class for debug-mode helpers used during development.
///
/// These utilities are intended to be conditionally invoked based on
/// `AppConfig.debugShowPayload` or similar feature flags.
class DebugUtils {
  /// Shows a dialog with the formatted JSON payload.
  ///
  /// This is intended to be used when `AppConfig.debugShowPayload` is true.
  static Future<void> showPayloadDialog({
    BuildContext? context,
    required String title,
    required dynamic payload,
    VoidCallback? onProceed,
  }) async {
    final effectiveContext = context ?? NavigationService.context;
    if (effectiveContext == null) return;

    final formattedPayload = const JsonEncoder.withIndent(
      '  ',
    ).convert(payload);

    await showDialog<void>(
      context: effectiveContext,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              formattedPayload,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: formattedPayload));
              showInfoSnackBar(context, 'Payload copied to clipboard');
            },
            child: const Text('Copy'),
          ),
          if (onProceed != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onProceed();
              },
              child: const Text('Proceed Anyway'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
