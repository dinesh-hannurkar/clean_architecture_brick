# Data Transfer Object (DTO) Conventions

## Purpose

DTOs are responsible for **serialization** and **deserialization** of data between the application and external sources (APIs, databases). They:
- Live in the **data layer** (`lib/data/models/`)
- Convert between JSON and domain entities
- Handle data transformation and validation
- Are **separate** from domain entities

## Naming Conventions

### File Naming
- Use snake_case: `user_model.dart`, `auth_token_model.dart`
- Suffix with `_model.dart`

### Class Naming
- Use PascalCase with "Model" suffix: `UserModel`, `AuthTokenModel`
- Match the corresponding entity name + "Model"

**Example:**
```
Domain Entity: User (lib/domain/entities/user.dart)
DTO Model: UserModel (lib/data/models/user_model.dart)
```

## Structure

DTOs should:
1. Extend or contain a domain entity
2. Provide JSON serialization methods
3. Include validation logic
4. Handle nullable JSON fields

**Standard Pattern:**

```dart
import 'package:app/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
  });

  /// Creates a [UserModel] from JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String?,
      photoUrl: json['photo_url'] as String?,
    );
  }

  /// Converts this [UserModel] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
    };
  }

  /// Creates a [UserModel] from a domain [User] entity.
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }
}
```

## JSON Field Mapping

### Naming
- Use **snake_case** for JSON keys (API standard)
- Use **camelCase** for Dart properties

**Example:**
```dart
// JSON: { "first_name": "John" }
// Dart: String firstName
```

### Type Safety
- Always cast JSON values: `json['id'] as String`
- Handle nullable fields with `?`: `json['name'] as String?`
- Validate required fields in `fromJson`

### Nested Objects
```dart
factory OrderModel.fromJson(Map<String, dynamic> json) {
  return OrderModel(
    id: json['id'] as String,
    user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    items: (json['items'] as List)
        .map((item) => ItemModel.fromJson(item as Map<String, dynamic>))
        .toList(),
  );
}
```

## Validation

Validate data in `fromJson`:

```dart
factory UserModel.fromJson(Map<String, dynamic> json) {
  final id = json['id'] as String?;
  final email = json['email'] as String?;

  if (id == null || id.isEmpty) {
    throw const ValidationFailure(message: 'User ID is required');
  }

  if (email == null || !_isValidEmail(email)) {
    throw const ValidationFailure(message: 'Valid email is required');
  }

  return UserModel(
    id: id,
    email: email,
    displayName: json['display_name'] as String?,
    photoUrl: json['photo_url'] as String?,
  );
}
```

## Date/Time Handling

Use ISO 8601 format for timestamps:

```dart
factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
  return AuthTokenModel(
    accessToken: json['access_token'] as String,
    refreshToken: json['refresh_token'] as String,
    expiresAt: DateTime.parse(json['expires_at'] as String),
  );
}

Map<String, dynamic> toJson() {
  return {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'expires_at': expiresAt.toIso8601String(),
  };
}
```

## Lists and Collections

```dart
// JSON: { "tags": ["flutter", "dart"] }
factory ArticleModel.fromJson(Map<String, dynamic> json) {
  return ArticleModel(
    tags: (json['tags'] as List).cast<String>(),
  );
}

// JSON: { "metadata": { "key": "value" } }
factory ConfigModel.fromJson(Map<String, dynamic> json) {
  return ConfigModel(
    metadata: Map<String, String>.from(json['metadata'] as Map),
  );
}
```

## Enums

Convert string values to enums:

```dart
enum UserRole { admin, user, guest }

factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    role: UserRole.values.byName(json['role'] as String),
  );
}

Map<String, dynamic> toJson() {
  return {
    'role': role.name,
  };
}
```

## Code Generation (Optional)

For complex models, consider using `json_serializable`:

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
```

## Testing DTOs

Test serialization and deserialization:

```dart
test('fromJson creates valid UserModel', () {
  final json = {
    'id': '123',
    'email': 'test@example.com',
    'display_name': 'Test User',
  };

  final model = UserModel.fromJson(json);

  expect(model.id, '123');
  expect(model.email, 'test@example.com');
  expect(model.displayName, 'Test User');
});

test('toJson creates valid JSON', () {
  const model = UserModel(
    id: '123',
    email: 'test@example.com',
    displayName: 'Test User',
  );

  final json = model.toJson();

  expect(json['id'], '123');
  expect(json['email'], 'test@example.com');
  expect(json['display_name'], 'Test User');
});
```

## Best Practices

### ✅ DO
- Keep DTOs in the data layer
- Use snake_case for JSON keys
- Validate required fields
- Provide type-safe conversions
- Test serialization/deserialization
- Handle nullable fields explicitly

### ❌ DON'T
- Put DTOs in domain layer
- Use dynamic types
- Skip null checks
- Mutate DTOs after creation
- Mix serialization logic with business logic
- Use DTOs outside the data layer
