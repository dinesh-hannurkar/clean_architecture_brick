/// Global configuration for the application.
///
/// Values are primarily loaded from environment variables using `String.fromEnvironment`.
class AppConfig {
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'App',
  );
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://velexp.com',
  );

  static const int apiTimeout = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 30000,
  );

  // Support
  static const String supportEmail = String.fromEnvironment(
    'SUPPORT_EMAIL',
    defaultValue: 'support@velexp.com',
  );
  static const String supportPhone = String.fromEnvironment('SUPPORT_PHONE');

  // Third Party
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');
  static const String googleMapsKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
  );

  // Feature Flags
  static const bool enableOfflineMode = bool.fromEnvironment(
    'ENABLE_OFFLINE_MODE',
    defaultValue: true,
  );
  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );
  static const bool isMaintenanceMode = bool.fromEnvironment(
    'MAINTENANCE_MODE',
    defaultValue: false,
  );

  // Debug Flags
  static const bool debugShowPayload = false; // Toggle as needed for any API
}
