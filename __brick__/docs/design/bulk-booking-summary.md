# Bulk Booking Summary Screen UI Specifications

**Version:** 1.0.0
**Status:** Ready for Implementation
**Designer:** UI/UX Designer

---

## 1. Overview
The **Bulk Booking Summary** screen allows users to review multiple selected orders before processing a unified payment/booking. It displays a consolidated list of shipments and a grand total.

**Entry Point:** "Book Now" button from `ToShipScreen` (Selection Mode).

---

## 2. Layout Structure

### A. App Bar
- **Title:** "Bulk Booking Review".
- **Subtitle:** "3 Orders (Domestic)".

### B. Summary List (Scrollable)
- **Item Component:** Compact version of `OrderCard`.
  - **Left:** Order ID.
  - **Middle:** Customer Name.
  - **Right:** Weight & Cost (e.g., "5kg | ₹450").
  - **Action:** Remove (Trash icon) - allows removing an order from the bulk batch.

### C. Payment Configuration
- **Payment Method:** (Reuse from Single Booking).
  - Wallet / Online / COD.
- **Total Weight:** Display aggregate weight.

### D. Persistent Footer
- **Layout:** Same as Single Booking.
- **Content:**
  - **Total Cost:** Sum of all individual order costs.
  - **Button:** "Pay & Book All" (`primary.500`).

---

## 3. Interaction Logic

### Bulk Validation
- On load, the screen might need to validate if all selected orders have sufficient details (e.g., weights, pincodes). 
- **Error State:** If an order is missing info (e.g., "Weight 0"), show a warning icon on that card. Disable "Pay & Book All" until fixed or removed.

### Success Flow
- **Action:** "Pay & Book All" -> Process Payment -> Bulk Creation API.
- **Result:** Navigate to "Orders Created" success screen (or back to Home).

---
