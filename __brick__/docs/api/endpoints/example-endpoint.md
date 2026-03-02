# API Endpoint Documentation Template

## Endpoint Name

**Method:** `GET | POST | PUT | DELETE`
**Path:** `/api/v1/resource`
**Auth Required:** Yes / No

## Request

### Headers
```
Authorization: Bearer <token>
Content-Type: application/json
```

### Body (for POST/PUT)
```json
{
  "field": "value"
}
```

## Response

### Success (200)
```json
{
  "data": {},
  "message": "Success"
}
```

### Error (4xx/5xx)
```json
{
  "error": "Error message",
  "code": 400
}
```

## Notes
- Add any special behaviour or edge cases here.
