# International Shipping API Documentation

## Overview

This document defines the data structures and API contracts for the International Shipping module in Project App.

## Data Structures

### 1. Shipper
Represents the sender of an international shipment.

```dart
class Shipper {
  final String name;
  final String? contactName;
  final String mobile;
  final String? telephone;
  final String? email;
  final String documentType; // e.g., Aadhar, PAN
  final String documentNumber;
  final String houseFlatNo;
  final String streetArea;
  final String city;
  final String state;
  final String pincode;
}
```

### 2. Consignee
Represents the recipient of an international shipment.

```dart
class Consignee {
  final String destination; // Country/Region
  final String name;
  final String? contactName;
  final String mobile;
  final String? telephone;
  final String? email;
  final String houseFlatNo;
  final String streetArea;
  final String city;
  final String state;
  final String pincode;
}
```

### 3. Shipment Content
Details regarding the items being shipped and their values.

```dart
class ShipmentContent {
  final String contentDescription;
  final String type; // DOX or SPX
  final int pieces;
  final double weight;
  final String currency; // default: INR
  final String csbType; // default: CSB4
  final double shipmentValue;
  final String termOfInvoice; // default: FOB
  final String invoiceNo;
  final DateTime invoiceDate;
  final String? instructions;
  final String? companyCode;
}
```

### 4. Package Dimensions
Physical dimensions for volumetric weight calculation.

```dart
class PackageDimension {
  final double length;
  final double width;
  final double height;
  final double deadWeight;
  final double volumetricWeight;
}
```

### 5. Performa Item
Line items for the Performa Invoice.

```dart
class PerformaItem {
  final String boxNo;
  final String hsnCode;
  final String description;
  final int quantity;
  final double weight;
  final double rate;
  final double amount;
}
```

## Validation Rules

### KYC Requirements
- `documentType` and `documentNumber` are strictly mandatory for international shipments.
- Address fields must be complete (House No + Street + City + State + Pincode).

### Customs Compliance
- `hsnCode` is required for all performa items.
- `invoiceDate` must not be in the future.
- `shipmentValue` must be greater than zero.

## API Integration

### Endpoint: Create International Booking
**Method:** `POST`  
**Route:** `/api/v1/international/bookings`

**Request Body:**
```json
{
  "shipper": { ... },
  "consignee": { ... },
  "content": { ... },
  "dimensions": [ ... ],
  "performa_items": [ ... ]
}
```

**Response:**
```json
{
  "order_id": "INT-12345",
  "tracking_no": "VEL-INT-9988",
  "status": "CREATED"
}
```
