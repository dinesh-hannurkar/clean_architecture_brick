# Shipping API Endpoints

## Overview
Endpoints related to order history, serviceability, and pincode lookups.

## Endpoints

### 1. Pincode Search
Dynamic autocomplete search for cities based on pincode or city name.

- **Method**: `POST`
- **Route**: `/get_city_pincodes/`
- **Auth Required**: Yes (Token prefix)

#### Request Payload
```json
{
  "user_id": 1,
  "q": "400", // Search term (min 3 chars)
  "call_from": "booking"
}
```

#### Response (200 OK)
```json
{
  "entries": [
    {
      "id": 101,
      "name": "Mumbai",
      "pincode": "400001",
      "state": "Maharashtra"
    },
    {
      "id": 102,
      "name": "Andheri",
      "pincode": "400053",
      "state": "Maharashtra"
    }
  ]
}
```

---

### 2. Domestic History
Fetches a filtered list of domestic shipments.

- **Method**: `POST`
- **Route**: `/domestic-history/filtered/`
- **Auth Required**: Yes (Token prefix)

#### Request Payload
```json
{
  "page": 1,
  "search": "VEL123",
  "status": "In Transit"
}
```

#### Response (200 OK)
```json
{
  "count": 1,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 5001,
      "order_id": "VEL12345",
      "status": "In Transit",
      "destination": "Bangalore",
      "date_created": "2026-02-01T10:00:00Z"
    }
  ]
}
```

---

### 3. International History
Fetches a filtered list of international shipments.

- **Method**: `POST`
- **Route**: `/international-history/filtered/`
- **Auth Required**: Yes (Token prefix)

#### Request Payload / Response
Similar structure to **Domestic History**.

---

### 4. International Rate
Fetches shipping rates and delivery estimates for international destinations.

- **Method**: `POST`
- **Route**: `/get-international-rate-api/`
- **Auth Required**: Yes (Token prefix)

#### Request Payload
```json
{
  "destination": "United Arab Emirates",
  "destCode": "AE",
  "dropPincode": "DXB123",
  "weight": 1.5
}
```

#### Response (200 OK)
```json
{
  "rate": 1000.0,
  "fscPercent": 10.0,
  "fscAmount": 100.0,
  "gstPercent": 18.0,
  "gstAmount": 198.0,
  "finalRate": 1298.0,
  "actualFinalRate": 1298.0,
  "edd": "2026-02-12",
  "minExpectedDeliveryDays": 3,
  "maxExpectedDeliveryDays": 5
}
```

---

### 5. International Bulk Temp Booking
Creates multiple temporary international bookings in a single request.

- **Method**: `POST`
- **Route**: `/portal/intl/temp-booking/`
- **Auth Required**: Yes (Token prefix)

#### Request Payload
Accepts a list of booking requests.

#### Response (200 OK)
```json
{
  "status": "success",
  "success_bookings": [
    {
      "status": "success",
      "temp_id": 12345,
      "pieces": "1",
      "amount": 1500.0
    }
  ],
  "error_bookings": [],
  "total_amount": 1500.0
}
```

---

### 6. International Bulk Payment Initialization
Initializes payment for a set of international temporary bookings.

- **Method**: `POST`
- **Route**: `/portal/intl/payment-init/`
- **Auth Required**: Yes (Token prefix)

#### Request Payload
```json
{
  "temp_ids": [12345, 12346],
  "payment_method": "online|wallet|cop",
  "wallet_amount_paid": 500.0,
  "online_pop_amount_paid": 1000.0
}
```

---

### 7. Shopify Order Sync
Synchronizes orders from a connected Shopify store.

- **Method**: `POST`
- **Route**: `/shopify/sync-orders/`
- **Auth Required**: Yes

#### Request Payload
```json
{
  "user_id": 1,
  "first": 10,
  "after": "cursor_string",
  "year_month": "2024-02",
  "filter": "order_name_or_id"
}
```

---

### 8. Shopify Order Fulfillment
Marks an entire Shopify order as fulfilled and adds tracking information.

- **Method**: `POST`
- **Route**: `/shopify/fulfill-order/`
- **Auth Required**: Yes

#### Request Payload
```json
{
  "user_id": 1,
  "year_month": "2024-02",
  "fulfillment_order_id": "gid://shopify/FulfillmentOrder/123",
  "tracking_company": "App",
  "tracking_number": "VEL123456",
  "tracking_url": "https://trace.app.in/VEL123456",
  "notify_customer": true
}
```
---
 
### 7. International Countries
Fetches a list of served countries for international shipping.
 
- **Method**: `POST`
- **Route**: `/get-intl-customer-countries-api/`
- **Auth Required**: Yes (Token prefix)
 
#### Request Payload
```json
{
  "user_id": 1
}
```
 
#### Response (200 OK)
```json
[
  {
    "name": "AUSTRALIA - MAIN",
    "iso": "AU",
    "phonecode": "61"
  },
  {
    "name": "AUSTRALIA - REST",
    "iso": "AU",
    "phonecode": "61"
  }
]
```
