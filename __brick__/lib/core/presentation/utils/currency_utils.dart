import 'package:intl/intl.dart';

/// Utility class for formatting currency values.
class CurrencyUtils {
  static final _formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  /// Formats a double [amount] into an Indian Rupee string (e.g., ₹1,234.56).
  static String format(double amount) {
    return _formatter.format(amount);
  }

  /// Formats a double [amount] into a compact Indian Rupee string (e.g., ₹1.23K).
  static String formatCompact(double amount) {
    return NumberFormat.compactCurrency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    ).format(amount);
  }
}
