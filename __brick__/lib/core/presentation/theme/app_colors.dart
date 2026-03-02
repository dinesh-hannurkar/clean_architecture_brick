import 'package:flutter/material.dart';

/// Brand color palette for {{app_display_name}}.
///
/// Primary:   #{{primary_color}}
/// Secondary: #{{secondary_color}}
///
/// To change colors, update brick.yaml variables and re-generate.
class AppColors {
  // ── Primary Palette ────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF{{primary_color}});
  static const Color primaryDark = Color(0xFF{{secondary_color}});
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFD1E4FF);
  static const Color onPrimaryContainer = Color(0xFF001D36);

  // ── Secondary Palette ──────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF{{secondary_color}});
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD7E2FF);
  static const Color onSecondaryContainer = Color(0xFF001B3F);

  // ── Tertiary Palette ───────────────────────────────────────────────────────
  static const Color tertiary = Color(0xFF7D5260);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFFD8E4);
  static const Color onTertiaryContainer = Color(0xFF31111D);

  // ── Error Palette ──────────────────────────────────────────────────────────
  static const Color error = Color(0xFFF44336);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color onErrorContainer = Color(0xFF410E0B);

  // ── Background & Surface ───────────────────────────────────────────────────
  static const Color background = Color(0xFFF5F5F5);
  static const Color onBackground = Color(0xFF212121);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF212121);
  static const Color surfaceVariant = Color(0xFFEEEEEE);
  static const Color onSurfaceVariant = Color(0xFF757575);
  static const Color outline = Color(0xFFE0E0E0);
  static const Color outlineVariant = Color(0xFFBDBDBD);

  // ── Semantic Colors ────────────────────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF388E3C);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningDark = Color(0xFFF57C00);
  static const Color info = Color(0xFF2196F3);
}
