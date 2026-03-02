# Environment Configuration Guide

## Overview

This guide documents environment-specific configurations, variable management, and best practices for Project App.

---

## Table of Contents

- [Environment Variables](#environment-variables)
- [Build Flavors](#build-flavors)
- [Firebase Configuration](#firebase-configuration)
- [API Configuration](#api-configuration)
- [Feature Flags](#feature-flags)
- [Security Configuration](#security-configuration)
- [Local Development](#local-development)

---

## Environment Variables

### Configuration File

Project App uses `.env` files for environment-specific configuration.

**File Locations:**
- `.env.example` - Template with all variables documented
- `.env` - Local configuration (gitignored, create from template)

**Creating Local Configuration:**
```bash
cp .env.example .env
# Edit .env with your specific values
```

### Variable Categories

#### API Configuration

| Variable | Environment | Description | Example |
|----------|------------|-------------|---------|
| `DEV_API_BASE_URL` | Development | Dev API endpoint | `https://api-dev.app.com` |
| `STAGING_API_BASE_URL` | Staging | Staging API endpoint | `https://api-staging.app.com` |
| `PROD_API_BASE_URL` | Production | Production API endpoint | `https://api.app.com` |
| `*_API_TIMEOUT` | All | Request timeout (ms) | `30000` |

#### Firebase Configuration

| Variable | Description | Example |
|----------|-------------|---------|
| `DEV_FIREBASE_PROJECT_ID` | Dev Firebase project | `app-dev-xxxxx` |
| `STAGING_FIREBASE_PROJECT_ID` | Staging Firebase project | `app-staging-xxxxx` |
| `PROD_FIREBASE_PROJECT_ID` | Production Firebase project | `app-prod-xxxxx` |
| `*_FCM_SENDER_ID` | Firebase Cloud Messaging sender ID | `123456789012` |

#### Authentication

| Variable | Description | Platform | Example |
|----------|-------------|----------|---------|
| `GOOGLE_CLIENT_ID_ANDROID` | Google OAuth client ID | Android | `xxxxx.apps.googleusercontent.com` |
| `GOOGLE_CLIENT_ID_IOS` | Google OAuth client ID | iOS | `xxxxx.apps.googleusercontent.com` |

#### Feature Flags

| Variable | Description | Default | Values |
|----------|-------------|---------|--------|
| `ENABLE_OFFLINE_MODE` | Enable local persistence | `true` | `true` / `false` |
| `ENABLE_ANALYTICS` | Enable analytics tracking | `false` | `true` / `false` |
| `ENABLE_CRASH_REPORTING` | Enable crash reports | `true` | `true` / `false` |
| `ENABLE_DEBUG_LOGGING` | Verbose debug logs | `true` | `true` / `false` |

#### Logging

| Variable | Description | Values |
|----------|-------------|--------|
| `LOG_LEVEL_DEV` | Development log level | `debug` / `info` / `warning` / `error` |
| `LOG_LEVEL_STAGING` | Staging log level | `debug` / `info` / `warning` / `error` |
| `LOG_LEVEL_PROD` | Production log level | `warning` / `error` |

---

## Build Flavors

### Flavor Definitions

Project App uses Gradle product flavors to manage environment-specific builds:

| Flavor | Application ID | App Name | Use Case |
|--------|---------------|----------|----------|
| **dev** | `com.app.app.dev` | "App Dev" | Local development, feature testing |
| **staging** | `com.app.app.staging` | "App Staging" | Pre-production QA, client demos |
| **prod** | `com.app.app` | "App" | Production release |

### Building for Specific Environments

```bash
# Development
flutter run --flavor dev
flutter build apk --flavor dev --debug

# Staging
flutter run --flavor staging
flutter build apk --flavor staging --release

# Production
flutter build apk --flavor prod --release
flutter build appbundle --flavor prod --release  # For Play Store
```

### Flavor-Specific Configuration

Each flavor automatically receives:

1. **Unique Application ID**
   - Allows multiple builds installed side-by-side
   - Example: Install dev, staging, and prod on same device

2. **Branded App Name**
   - Visual distinction in app drawer
   - Clear identification of environment

3. **Version Suffix** (dev and staging only)
   - Example: `0.1.0-dev`, `0.1.0-staging`

### Accessing Flavor in Code

```dart
// Future implementation: Environment detection
enum Environment { dev, staging, prod }

Environment getEnvironment() {
  // Implementation based on flavor configuration
  // Will be implemented by Backend Engineer
}
```

---

## Firebase Configuration

### Multi-Project Setup

Project App requires separate Firebase projects for each environment:

#### Development Environment
- **Project ID**: `app-dev-xxxxx`
- **Purpose**: Development testing, feature experimentation
- **Access**: All developers

#### Staging Environment
- **Project ID**: `app-staging-xxxxx`
- **Purpose**: Pre-production validation, client demos
- **Access**: QA team, stakeholders

#### Production Environment
- **Project ID**: `app-prod-xxxxx`
- **Purpose**: Live user traffic
- **Access**: Limited to release managers

### Configuration Files

Firebase configuration files should be placed in:

```
android/app/src/dev/google-services.json       # Dev config
android/app/src/staging/google-services.json   # Staging config
android/app/src/prod/google-services.json      # Prod config

ios/Runner/Dev/GoogleService-Info.plist        # Dev config
ios/Runner/Staging/GoogleService-Info.plist    # Staging config
ios/Runner/Prod/GoogleService-Info.plist       # Prod config
```

> [!WARNING]
> Firebase configuration files contain sensitive project IDs. Ensure they are properly gitignored or use environment-specific secrets.

### Firebase Services

#### Firebase Messaging (Push Notifications)

**Configuration:**
- Each environment has unique FCM sender ID
- Server key stored in backend (not in mobile app)
- Mobile app receives notifications via FCM token

**Testing:**
```bash
# Send test notification via Firebase Console
# Select appropriate project (dev/staging/prod)
```

#### Firebase Crashlytics (Future)

**Configuration:**
- Enabled only in staging and production
- Disabled in development to avoid noise
- Automatic crash reporting with stack traces

---

## API Configuration

### Endpoint Management

#### Base URLs

Different environments connect to different API backends:

```dart
// Future implementation
class ApiConfig {
  static String get baseUrl {
    switch (environment) {
      case Environment.dev:
        return 'https://api-dev.app.com';
      case Environment.staging:
        return 'https://api-staging.app.com';
      case Environment.prod:
        return 'https://api.app.com';
    }
  }
}
```

### Timeout Configuration

Environment-specific timeout values:

- **Development**: 30 seconds (slower debugging)
- **Staging**: 30 seconds (thorough testing)
- **Production**: 15 seconds (fast user experience)

### Authentication

#### OAuth 2.0 Token-Based

All environments use OAuth 2.0 with Google Sign-In:

1. User authenticates via Google
2. App receives OAuth token
3. Token sent with all API requests
4. Backend validates token

**Security:**
- Tokens stored in encrypted storage (`flutter_secure_storage`)
- Automatic token refresh
- Session timeout enforcement (30 minutes)

---

## Feature Flags

### Purpose

Feature flags allow:
- Gradual feature rollout
- A/B testing
- Emergency feature disable
- Environment-specific behavior

### Recommended Flags

| Flag | Dev | Staging | Prod | Description |
|------|-----|---------|------|-------------|
| `ENABLE_OFFLINE_MODE` | ✅ | ✅ | ✅ | Local data persistence |
| `ENABLE_ANALYTICS` | ❌ | ✅ | ✅ | User behavior tracking |
| `ENABLE_CRASH_REPORTING` | ❌ | ✅ | ✅ | Automatic crash reports |
| `ENABLE_DEBUG_LOGGING` | ✅ | ✅ | ❌ | Verbose console logs |
| `ENABLE_PERFORMANCE_OVERLAY` | ✅ | ❌ | ❌ | Flutter performance stats |

### Implementation

```dart
// Future implementation
class FeatureFlags {
  static bool get offlineMode => 
      dotenv.env['ENABLE_OFFLINE_MODE'] == 'true';
  
  static bool get analytics => 
      dotenv.env['ENABLE_ANALYTICS'] == 'true';
  
  // ... other flags
}
```

---

## Security Configuration

### Encrypted Storage

Sensitive data stored using `flutter_secure_storage`:

**Stored Items:**
- OAuth tokens
- User credentials
- Session tokens
- API keys (if needed)

**NOT Stored:**
- User passwords (never stored locally)
- Keystore passwords (only in CI secrets)
- Firebase server keys (backend only)

### TLS Requirements

All environments enforce TLS 1.3:

```dart
// HTTP client configuration
Dio dio = Dio(
  BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: Duration(milliseconds: timeout),
    receiveTimeout: Duration(milliseconds: timeout),
  ),
)..httpClientAdapter = IOHttpClientAdapter(
  createHttpClient: () {
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => false;
    return client;
  },
);
```

### Data Leak Prevention

**Rules:**
1. No sensitive data in logs (production)
2. No user PII in analytics events
3. No plain-text credential storage
4. API keys in environment variables, not code

---

## Local Development

### Initial Setup

1. **Clone Repository**
   ```bash
   git clone https://github.com/dinesh-hannurkar/app-application.git
   cd app
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Create Environment File**
   ```bash
   cp .env.example .env
   ```

4. **Edit Configuration**
   ```bash
   # macOS/Linux
   nano .env
   
   # Windows
   notepad .env
   ```

5. **Configure Firebase** (when available)
   - Download `google-services.json` from Firebase Console
   - Place in `android/app/src/dev/`
   - Repeat for iOS if needed

6. **Run Development Build**
   ```bash
   flutter run --flavor dev
   ```

### Switching Environments

```bash
# Run on development environment
flutter run --flavor dev

# Run on staging environment
flutter run --flavor staging

# Build production APK (testing only)
flutter build apk --flavor prod --release
```

### Environment Verification

```bash
# Check current configuration
flutter doctor
flutter pub get
flutter analyze

# Test environment-specific build
flutter build apk --flavor dev --debug
```

---

## Best Practices

### DO ✅

- Use `.env.example` as documentation for all variables
- Keep `.env` in `.gitignore`
- Use descriptive variable names
- Document all new variables
- Use environment-specific values
- Encrypt sensitive data at rest
- Validate configuration on app start

### DON'T ❌

- Commit `.env` files to version control
- Hard-code API endpoints or secrets
- Store passwords in plain text
- Use production credentials in development
- Share API keys publicly
- Log sensitive data
- Bypass TLS certificate validation (except dev)

---

## Troubleshooting

### Environment Not Loading

**Problem**: App not reading `.env` file

**Solution**:
1. Verify `.env` exists in project root
2. Rebuild app after changing `.env`
3. Check for syntax errors in `.env`

### Wrong API Endpoint

**Problem**: App connecting to wrong environment

**Solution**:
1. Verify correct flavor is selected
2. Check `dotenv` package is configured
3. Rebuild app to pick up new configuration

### Firebase Not Initialized

**Problem**: Firebase crashes on startup

**Solution**:
1. Verify `google-services.json` exists in correct flavor directory
2. Check Firebase project ID matches configuration
3. Ensure Firebase dependencies are in `pubspec.yaml`

---

## Migration Guide

### Adding New Environment Variable

1. **Add to `.env.example`**
   ```bash
   # New variable with description
   NEW_VARIABLE=default_value
   ```

2. **Update Documentation**
   - Add to this file under appropriate category
   - Document purpose, values, and examples

3. **Notify Team**
   - Update `.env` files locally
   - Update CI/CD secrets if needed

### Changing Environment Structure

1. **Update Build Configuration**
   - Modify `android/app/build.gradle.kts`
   - Update iOS schemes if applicable

2. **Update CI/CD Workflows**
   - Modify GitHub Actions workflows
   - Update secret references

3. **Test All Environments**
   ```bash
   flutter build apk --flavor dev --debug
   flutter build apk --flavor staging --release
   flutter build apk --flavor prod --release
   ```

---

**Role**: DevOps Infrastructure  
**Last Updated**: 2026-01-22  
**Version**: 1.0
