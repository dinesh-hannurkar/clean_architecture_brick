# API Integration Guide

## Overview
This guide explains the standard patterns and protocols for integrating the Flutter application with the backend REST API.

## Authentication

### Header Format
Most secure endpoints require an `Authorization` header. The prefix used in this project is `Token` (unless specified as `Bearer` for certain modules).

```
Authorization: Token <your_access_token>
```

### Token Management
- Tokens are retrieved via the `AuthRemoteDataSource`.
- Tokens are persisted securely using `flutter_secure_storage`.
- Injected into every request via the `HttpClient` interceptor.

## Error Handling

### Standard Error Format
The API follows a consistent error response structure:

```json
{
  "error": "ERROR_CODE",
  "message": "Human readable message explaining what went wrong."
}
```

### Common Status Codes
| Code | Meaning |
|------|---------|
| 200 | Success |
| 400 | Validation Error / Bad Request |
| 401 | Unauthorized (Missing or Invalid Token) |
| 403 | Forbidden (Insufficient Permissions) |
| 500 | Internal Server Error |

## Implementation Pattern

### 1. Define DTO (Data Transfer Object)
DTOs handle the JSON mapping using `json_serializable`.

```dart
@JsonSerializable()
class UserDto {
  final int id;
  final String email;
  
  User toDomain() => User(id: id.toString(), email: email);
}
```

### 2. Remote Data Source
Use `HttpClient` (Dio wrapper) to make requests.

```dart
final response = await _httpClient.dio.post('/endpoint/', data: params);
return Dto.fromJson(response.data);
```

### 3. Repository
Map DTOs to Domain Entities and catch exceptions using `fpdart`'s `Either`.

```dart
Future<Either<Failure, User>> getUser() async {
  try {
    final dto = await remoteDataSource.getUser();
    return Right(dto.toDomain());
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```
