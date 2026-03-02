# Booking Screen UI Specifications

**Version:** 1.0.0
**Status:** Ready for Implementation
**Designer:** UI/UX Designer

---

## 1. Overview
The Booking screen handles order fulfillment for both Domestic and International shipments. While the fields differ between types, the **visual language remains identical**. It features a single, scrollable form divided into logical sections (Estimate, Shipper, Receiver, etc.) with a persistent bottom summary and action bar.

**Reference:** `uploaded_image_1769579307550.png`

---

## 2. Layout Structure

### A. App Bar (Top)
- **Background:** Linear Gradient (Primary Brand Color to Dark Brand Color).
- **Leading:** Back arrow button.
- **Title:** "Domestic Booking" or "International Booking".
- **Subtitle:** "Single" or order-specific identifier.
- **Icons:** Profile/Account icon on the right.

### B. Form Body (Scrollable)
- **Background:** `neutral.100` (`#F5F5F5`).
- **Structure:** A single `SingleChildScrollView` containing various section widgets.

### C. Persistent Footer (Fixed)
- **Background:** White (`#FFFFFF`).
- **Elevation:** `shadow_xl` (top-facing).
- **Content:**
  - **Left:** Cost breakdown (Sub-items like Rate, FSC, FOV, etc.) + Grand Total ("Freight Cost").
  - **Right:** "Make Payment" or "Process Booking" primary button.

---

## 3. Form Elements & Design Tokens

### Section Headers
- **Indicator:** Primary blue circle (`32x32dp`) with white centered number.
- **Text:** Bold title in `primary.500` (`#0467B0`), `h5` size.
- **Padding:** `vertical: 16dp`.

### Input Field Style (Standard)
- **Container:** White background card with very subtle border.
- **Label:** Small grey text above the value, with a red asterisk `*` for required fields.
- **Value:** Black text, high contrast.
- **Height:** `56dp` to `64dp`.
- **Border:** `1px` solid `neutral.200` (`#EEEEEE`).
- **Groups:** Fields are often grouped in twos (50% width each) within a row.

### Dropdowns
- **Visual:** Same as input field.
- **Trailing:** `arrow_drop_down` icon in grey.
- **Interaction:** Opens a bottom sheet or selection dialog.

### Product/Service Selectors (Horizontal)
- **Card-style:** Rectangular cards with white background.
- **Border:** Blue border if selected, grey if unselected.
- **Top Label:** Service name (e.g., "VELOFREIGHT").
- **Bottom Value:** Price in blue box (if selected) or grey (if unselected).

### Radio Buttons & Checkboxes
- **Color:** `primary.500`.
- **Label:** `body1` size, aligned to the right of the control.

### Toggles (Switch)
- **Active Color:** `primary.500`.
- **Track Color:** `neutral.300`.

### Date Picker
- **Visual:** Same as input field with a trailing `calendar_today` icon.
- **Interaction:** Opens standard Material Date Picker.

### Package Dimensions (Table & Bottom Sheet)
- **Component:** "Size" Section.
- **Main Screen View:**
  - **Action:** "Add Package" button (Outlined or Text Button with Icon).
  - **Table:** A simple data table displaying added packages.
    - Headers: Length, Breadth, Height, Weight, Vol. Wt, Action (#).
    - Rows: Data for each package.
    - Empty State: "No pieces added" centered text.
- **Add Package Bottom Sheet:**
  - **Title:** "Add Package Details".
  - **Inputs:** 4 Horizontal inputs (Length, Breadth, Height, Weight).
  - **Layout:** Row of 4 small text fields + 1 Large Circular "Add" Button (Primary Color).
  - **Interaction:** Tapping "Add" verifies inputs, adds to list, clears inputs (or closes sheet).

---

## 4. Section Definitions (Example)

### 1. Estimate
- Origin Dropdown (Pincode - City)
- Destination Dropdown (Pincode - City)
- Origin Dropdown (Pincode - City)
- Destination Dropdown (Pincode - City)
- **Package Dimensions Widget:** (See Section 3.7). Replaces simple weight input.
  - Displays summary table of added pieces.
  - "Add" button opens Bottom Sheet for entering L/B/H/W.
- Shipment Value Input
- E-WayBill No. Input
- **Product Type Selection:** Custom horizontal list of price cards.

### 2. Shipper Details
- Shipper Name
- Shipper Mobile / Alternate Mobile
- Email
- House / Flat No / Landmark
- Full Address (TextArea / Multi-line)
- Pincode / State / City
- GST No. (Domestic Only)
- **KYC Document Type** (International Only) - Dropdown (Aadhar, Passport, PAN, Voter ID).
- **KYC Document Number** (International Only).
- **Upload KYC** (International Only) - File Upload Button.

### 3. Consignee Details (International)
- Consignee Name
- Consignee Mobile
- Email
- Address Line 1 / 2
- Country (Dropdown)
- State / City / Zipcode
- **Tax ID / VAT Number** (Optional depending on country).

### 4. Content Details
- Product Description
- Quantity
- **HS Code** (International Only).
- **Country of Manufacture** (International Only).
- Value
- Insurance Toggle.

---

## 5. Interaction Guidelines

- **Validation:** Real-time validation on focus loss. Required fields marked with red asterisks.
- **Focus:** The active field card should have a slightly more prominent border (`2px` primary) or elevation.
- **Footer Updates:** Total cost in the footer must update dynamically as fields like "Weight" or "Product Type" are modified.

---

## 6. Implementation Notes (Frontend)

### Package Dimensions Logic
- **State:** Use a `List<PackageItem>` to store added pieces.
- **Volumetric Weight Calculation:** `(L * B * H) / Divisor` (usually 5000 or 4000 depending on carrier). Auto-calculate this for the table.
- **Total Weight:** specific logic to sum up actual weight vs volumetric weight.
- **Bottom Sheet:** Use `showModalBottomSheet`.
  - Content: A widget named `AddPackageSheet`.
  - Layout: `Row(children: [Expanded(Field L), Expanded(Field B), ... FabAddButton])`.

### Reusable Field Widget
Create a generic `BookingInputField` that can handle text, dropdowns, and date pickers to ensure visual consistency.

```dart
class BookingField extends StatelessWidget {
  final String label;
  final String? value;
  final bool isRequired;
  final Widget? trailing;
  // ...
}
```

### Form Layout
Use `Row` with `Expanded` for the 2-column field layouts. Use `Padding` of `8dp` between fields in a group.

### Theming
Refer to `AppColors` for the primary blue (`#0467B0`) and dark variant (`#022B4A`) for the App Bar and footer buttons.

---
