# Booking Summary & Payment Screen UI Specifications

**Version:** 1.0.0
**Status:** Ready for Implementation
**Designer:** UI/UX Designer

---

## 1. Overview
The **Booking Summary & Payment** screen is the final step before order confirmation. It provides a concise review of the shipment details (Source, Destination, Contact Info) and allows the user to select a payment method.

**Reference:** `uploaded_media_1769594084938.png`

---

## 2. Layout Structure

### A. App Bar (Top)
- **Background:** Linear Gradient (`primary` to `primaryDark`).
- **Leading:** Back arrow (White).
- **Title:** "Booking Summary & Payment".
- **Subtitle:** "Single".
- **Actions:** None (or optional standard actions).

### B. content Body (Scrollable)
- **Background:** White (`#FFFFFF`).
- **Sections:**
  1.  **Shipment Summary List:** Key details in a 2-column grid format.
  2.  **Divider:** Horizontal line separator.
  3.  **Wallet Balance:** Display of current wallet funds.
  4.  **Payment Methods:** Selection list (Wallet, Online, Pay at Pickup).

### C. Persistent Footer (Fixed)
- **Background:** White (`#FFFFFF`) with Top Shadow.
- **Content:**
  - **Top Row:** Detailed Cost Breakdown (Rate, FSC, FOV, Pickup, ODA, GST).
  - **Bottom Row:**
    - Left: Total Freight Cost (Large Text).
    - Right: "Pay Now" Button (Primary Book).

---

## 3. UI Components & Styling

### A. Shipment Summary Section
- **Layout:** Vertical list of rows. Each row has two columns (Left aligned and Right aligned).
- **Typography:**
  - **Value:** `body1` (14px/16px), Color: `textPrimary` (`#000000` / `#212121`).
  - **Label:** `caption` (12px), Color: `textSecondary` (`#757575`).
- **Data Points (Example Patterns):**
  - Row 1: Source Pincode/City | Destination Pincode/City
  - Row 2: Sender Name | Receiver Mobile
  - ... (Repeated for strictly relevant info).

### B. Wallet Balance Section
- **Container:** Padding `16dp`.
- **Icon:** Wallet Icon (Custom or Material `account_balance_wallet`).
- **Text:** "₹ 4,000 Wallet Balance" (Bold).

### C. Payment Options
- **Item Layout:** Row with Icon (Checkbox/Radio) + Label text.
- **Options:**
  1.  **Pay with wallet** (Icon: Square Checkbox style - Suggesting toggle).
  2.  **Pay Online** (Icon: Circle Radio style).
  3.  **Pay at pickup** (Icon: Circle Radio style).
- **Styling:**
  - Text: `body1` (16px, Medium).
  - Icons: Large, readable size (`24dp`).

### D. Footer Specs
- **Breakdown Row:**
  - Small text items spaced evenly.
  - **Value:** Bold Black (`₹ 150.00`).
  - **Label:** Grey (`Rate`).
- **Total Row:**
  - **Total:** `h5` sized text (`₹ 812.80`) + "Freight Cost" caption.
  - **Button:** Full-height/Large button `Pay Now`. Color: `primary` (`#0467B0`).

---

## 4. Interaction Guidelines

- **Payment Selection:**
  - "Pay with wallet" is likely a **Use Wallet Balance** checkbox.
    - *Logic:* If checked, deduct from total. If balance covers total, other options might be disabled or hidden. If partial, user must select another method for the remainder.
  - "Pay Online" / "Pay at pickup" are Mutually Exclusive Radio Buttons.
- **Footer:** Same behavior as Booking Screen.

---
