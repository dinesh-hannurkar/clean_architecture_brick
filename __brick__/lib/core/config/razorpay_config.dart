/// Payment gateway configuration.
///
/// Keys are injected at build time via --dart-define.
/// Never hard-code keys here.
///
/// Usage:
/// flutter run \
///   --dart-define=PAYMENT_KEY_ID=your_key_id \
///   --dart-define=PAYMENT_KEY_SECRET=your_key_secret
class PaymentConfig {
  static const String keyId = String.fromEnvironment('PAYMENT_KEY_ID');
  static const String keySecret = String.fromEnvironment('PAYMENT_KEY_SECRET');
}
