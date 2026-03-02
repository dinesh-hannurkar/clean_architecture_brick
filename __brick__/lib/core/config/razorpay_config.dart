class RazorpayConfig {
  static const String keyId = String.fromEnvironment(
    'RAZORPAY_KEY_ID',
    defaultValue: 'rzp_test_placeholder',
  );
  static const String keySecret = String.fromEnvironment(
    'RAZORPAY_KEY_SECRET',
    defaultValue: 'placeholder_secret',
  );
}
