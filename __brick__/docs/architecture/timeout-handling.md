# API Timeout Handling

## Overview
The application now has comprehensive timeout and error handling with user-friendly displays.

## Architecture

### 1. Data Layer (Exceptions)
- **TimeoutException**: Thrown when HTTP requests time out
- Located in: `core/data/exceptions/exceptions.dart`

### 2. HTTP Client Configuration
- Connection timeout: 30 seconds
- Receive timeout: 60 seconds
- Automatically converts DioException timeouts to TimeoutException
- Located in: `core/data/network/http_client.dart`

### 3. Domain Layer (Failures)
- **TimeoutFailure**: Domain-level representation of timeout errors
- User-friendly message: "Request timed out. Please check your internet connection and try again."
- Located in: `core/domain/failures/failure.dart`

### 4. Repository Layer
- Maps TimeoutException → TimeoutFailure
- Example in: `features/your_feature/data/repositories/feature_repository_impl.dart`

```dart
try {
  final result = await _remoteDataSource.fetchOrders(...);
  return right((result.orders, result.pageInfo));
} on TimeoutException catch (e) {
  return left(TimeoutFailure(message: e.message ?? 'Request timed out'));
} on NetworkException catch (e) {
  return left(NetworkFailure(message: e.message ?? 'Network error'));
}
```

### 5. Presentation Layer

#### ErrorDisplay Widget
- Comprehensive error display widget with specific styling for different error types
- Located in: `core/presentation/widgets/error_display.dart`
- Features:
  - **Timeout errors**: Orange/amber theming with clock icon
  - **Network errors**: Blue theming with WiFi off icon
  - **Server errors**: Red theming with server icon
  - Optional retry button
  - Responsive design

#### Usage Example
```dart
if (state is ShippingLoadFailure) {
  return CenteredErrorDisplay(
    failure: state.failure,
    onRetry: () {
      context.read<ShippingBloc>().add(
        const ShippingOrdersFetched(),
      );
    },
  );
}
```

## Error Type Visual Indicators

| Error Type | Icon | Color | Message |
|------------|------|-------|---------|
| TimeoutFailure | ⏱️ access_time_filled | Orange | Connection Timeout |
| NetworkFailure | 📵 wifi_off_rounded | Blue | Network Error |
| ServerFailure | 🖥️ dns_outlined | Red | Server Error |
| AuthenticationFailure | 🔒 lock_outline | Purple | Authentication Failed |
| ValidationFailure | ⚠️ error_outline | Grey | Validation Error |

## Testing Timeout Scenarios

To test timeout handling:

1. **Simulate timeout** by adding artificial delay in remote data source
2. **Network issues** can be tested with airplane mode
3. **Server timeouts** can be simulated by pointing to slow endpoints

## Best Practices

1. Always catch `TimeoutException` before generic `Exception`
2. Provide specific, actionable error messages
3. Include retry functionality where appropriate
4. Use `ErrorDisplay` for consistent UX across the app

## Future Enhancements

- [ ] Add offline mode detection
- [ ] Implement exponential backoff for retries
- [ ] Add network quality indicators
- [ ] Cache last successful response for offline viewing
