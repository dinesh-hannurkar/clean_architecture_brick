# Authentication API Endpoints

## Overview
Handle user login via OTP or Password, and manage authentication state via tokens.

## Endpoints

### 1. Request OTP
Requests a one-time password to be sent to the user's mobile number.

- **Method**: `POST`
- **Route**: `/login_otp/`
- **Auth Required**: No

#### Request Payload
```json
{
  "phone": "9876543210" // 10-digit mobile number
}
```

#### Response (200 OK)
```json
{
  "status": "success",
  "message": "OTP sent successfully"
}
```

---

### 2. Verify OTP Login
Verifies the OTP sent to the user and returns authentication tokens.

- **Method**: `POST`
- **Route**: `/vel_otp_login/`
- **Auth Required**: No

#### Request Payload
```json
{
  "phone": "9876543210",
  "otp": "123456"
}
```

#### Response (200 OK)
```json
{
  "user": {
    "id": 1,
    "first_name": "John",
    "email": "john@example.com",
    "phone": "9876543210",
    "wallet_balance": 500.0,
    "is_kyc_verified": true
  },
  "access": "jwt_access_token_here",
  "refresh": "jwt_refresh_token_here"
}
```

---

### 3. Password Login
Standard login using username and password.

- **Method**: `POST`
- **Route**: `/vel_login/`
- **Auth Required**: No

#### Request Payload
```json
{
  "username": "john_doe",
  "password": "secure_password"
}
```

#### Response (200 OK)
Same format as **Verify OTP Login**.

---

### 4. User Profile
Fetches the current user's profile details.

- **Method**: `GET`
- **Route**: `/users/{user_id}/`
- **Auth Required**: Yes (Bearer Token)

#### Response (200 OK)
```json
{
  "id": 1,
  "first_name": "John",
  "email": "john@example.com",
  "phone": "9876543210",
  "wallet_balance": 500.0,
  "is_kyc_verified": true
}
```
