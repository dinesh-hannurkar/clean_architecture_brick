# API Endpoint: [Endpoint Name]

**Method**: `GET` / `POST` / `PUT` / `DELETE`  
**Route**: `/api/v1/resource`  
**Auth Required**: Yes / No (Roles: `Admin`, `User`)

## Description
Brief description of what this endpoint does.

## Request

### Headers
| Name | Type | Required | Description |
|------|------|----------|-------------|
| Authorization | String | Yes | Bearer token |

### Query Parameters
| Name | Type | Required | Description |
|------|------|----------|-------------|
| limit | Int | No | Max items (default: 10) |

### Body
```json
{
  "key": "value"
}
```

## Response

### Success (200 OK)
```json
{
  "id": "123",
  "status": "success"
}
```

### Error Responses

**400 Bad Request**
```json
{
  "code": "INVALID_INPUT",
  "message": "Field 'email' is required."
}
```

**401 Unauthorized**
```json
{
  "code": "AUTH_FAILED",
  "message": "Invalid token."
}
```

## Notes
- Any special behaviors or edge cases.
