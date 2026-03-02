# To Ship Screen UI Specifications

**Version:** 1.0.0
**Status:** Ready for Implementation
**Designer:** UI/UX Designer

---

## 1. Overview
The "To Ship" screen displays the active shipping orders that need to be processed. It features a sync header showing the last update time and a scrollable list of order cards with detailed shipping information.

**Reference:** `uploaded_image_1769509269493.png`

---

## 2. Layout Structure

### A. Title Bar Section
A header section below the App Bar containing the title and sync information.

**Layout:**
- **Background:** White (`#FFFFFF`) or `neutral.50` (`#FAFAFA`)
- **Padding:** `horizontal: 16dp, vertical: 12dp`
- **Border Bottom:** 1px solid `neutral.200` (`#EEEEEE`) for separation

**Content:**
1. **Left Side:**
   - **Title:** "Shopify Orders"
     - Style: `h6` (20px, Medium weight)
     - Color: `textPrimary` (`#212121`)
   - **Sync Status:** "Last Sync [Time]"
     - Style: `caption` (12px, Regular)
     - Color: `textSecondary` (`#757575`)
     - Format: "Last Sync 10:23 PM"

2. **Right Side:**
   - **Refresh Icon Button:**
     - Icon: `sync` or `refresh` (Material Icons)
     - Size: `24dp`
     - Color: `primary.500` (`#0467B0`)
     - Touch Target: `48x48dp`
     - Action: Triggers order sync/refresh

### B. Order List Section

**Container:**
- **Background:** `neutral.100` (`#F5F5F5`)
- **Padding:** `horizontal: 16dp, top: 8dp, bottom: 8dp`
- **Scroll:** Vertical scroll (ListView)

**Spacing:**
- Gap between cards: `12dp`

---

## 3. Order Card Component

Each order is displayed as a card with the following structure:

### Card Container
- **Background:** White (`#FFFFFF`)
- **Border Radius:** `lg` (12dp)
- **Elevation:** `shadow_sm` (2dp)
- **Padding:** `16dp`
- **Margin Bottom:** `12dp`

### Card Content Layout

#### Row 1: Order ID & Shipping Type (Left) | Date/Time (Right)
- **Order ID:**
  - Text: "#LSS26920" (example)
  - Style: `subtitle2` (14px, Medium)
  - Color: `primary.500` (`#0467B0`)
  - Tappable: Yes (opens order details)

- **Shipping Type Badge:**
  - Text: "Domestic" or "International"
  - Style: `caption` (12px, Medium)
  - Background: 
    - Domestic: `success.light` with 20% opacity
    - International: `warning.light` with 20% opacity
  - Text Color:
    - Domestic: `success.dark` (`#388E3C`)
    - International: `warning.dark` (`#F57C00`)
  - Padding: `horizontal: 8dp, vertical: 4dp`
  - Border Radius: `sm` (4dp)
  - Spacing from Order ID: `8dp`

- **Date/Time (Right-aligned):**
  - Text: "21 Jan 2026 • 10:20 PM"
  - Style: `caption` (12px, Regular)
  - Color: `textSecondary` (`#757575`)

#### Row 2: Customer Name | Item Count
- **Customer Name:**
  - Text: "Saraswati S" (example)
  - Style: `subtitle1` (16px, Regular)
  - Color: `textPrimary` (`#212121`)

- **Item Count (Right-aligned):**
  - Text: "2 Items"
  - Style: `body2` (14px, Regular)
  - Color: `textPrimary` (`#212121`)

#### Row 3: Location | Weight
- **Location:**
  - Icon: `location_pin` (outlined)
  - Icon Size: `14dp`
  - Icon Color: `textSecondary` (`#757575`)
  - Text: "Mumbai, Maharashtra, 400076"
  - Style: `caption` (12px, Regular)
  - Color: `textSecondary` (`#757575`)
  - Max Lines: 1 (ellipsis if overflow)

- **Weight (Right-aligned):**
  - Icon: `inventory_2` or weight icon
  - Icon Size: `14dp`
  - Icon Color: `textSecondary` (`#757575`)
  - Text: "3 KG"
  - Style: `body2` (14px, Regular)
  - Color: `textPrimary` (`#212121`)

---

## 4. Detailed Card Layout (Flutter Structure)

```dart
Card(
  margin: EdgeInsets.only(bottom: 12),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  elevation: 2,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Order ID, Badge, Date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('#LSS26920', style: subtitle2, color: primary),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: successLight.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('Domestic', style: caption),
                ),
              ],
            ),
            Text('21 Jan 2026 • 10:20 PM', style: caption),
          ],
        ),
        SizedBox(height: 8),
        // Row 2: Customer Name, Item Count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Saraswati S', style: subtitle1),
            Text('2 Items', style: body2),
          ],
        ),
        SizedBox(height: 4),
        // Row 3: Location, Weight
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.location_pin, size: 14, color: textSecondary),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Mumbai, Maharashtra, 400076',
                    style: caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.inventory_2, size: 14, color: textSecondary),
                SizedBox(width: 4),
                Text('3 KG', style: body2),
              ],
            ),
          ],
        ),
      ],
    ),
  ),
)
```

---

## 5. Empty State

When there are no orders to ship:

- **Icon:** `inventory_2` (outlined) or custom illustration
- **Size:** `64dp`
- **Color:** `neutral.400`
- **Title:** "No Orders to Ship"
  - Style: `h6` (20px, Medium)
  - Color: `textPrimary`
- **Subtitle:** "New orders will appear here"
  - Style: `body2` (14px, Regular)
  - Color: `textSecondary`
- **Layout:** Centered in the available space

---

## 6. Loading State

While orders are being fetched or synced:

- **Skeleton Cards:** Show 3-5 shimmer placeholder cards matching the order card dimensions
- **OR** Standard Loading Indicator centered with text "Loading orders..."

---

## 7. Pull-to-Refresh

Enable pull-to-refresh gesture:
- **Indicator Color:** `primary.500` (`#0467B0`)
- **Action:** Triggers order sync, updates "Last Sync" time

---

## 8. Interaction Patterns

### Card Tap
- **Action:** Navigate to Order Details screen
- **Feedback:** Ripple effect on tap

### Refresh Button
- **Action:** Manually trigger sync
- **Feedback:** Icon rotation animation during sync
- **Duration:** `500ms` with `easeInOut` curve

---

## 9. Accessibility

- **Semantic Labels:** Each card must have a semantic label like "Order #LSS26920, Domestic, Saraswati S, 2 items"
- **Touch Targets:** All interactive elements minimum 48x48dp
- **Contrast:** All text meets WCAG AA standards
- **Screen Reader:** Proper focus order (top to bottom)

---

## 10. Colors Reference

- **Primary:** `#0467B0`
- **Text Primary:** `#212121`
- **Text Secondary:** `#757575`
- **Success (Domestic):** `#4CAF50` / `#388E3C`
- **Warning (International):** `#FF9800` / `#F57C00`
- **Border:** `#EEEEEE`
- **Background:** `#F5F5F5`
- **Card:** `#FFFFFF`

---

## 11. Implementation Notes

1. **Data Model:** Create `ShippingOrder` model with fields: `orderId`, `type` (Domestic/International), `customerName`, `location`, `dateTime`, `itemCount`, `weight`
2. **State Management:** Use BLoC/Cubit for order list state
3. **API Integration:** Sync endpoint should update last sync timestamp
4. **Pagination:** If order list is large, implement pagination or infinite scroll
5. **Search/Filter:** Consider adding search and filter options in future iterations

---

## 12. Bulk Selection Mode

### Activation
- **Trigger:** Long press on any order card.
- **Initial State:** 
  - The long-pressed card becomes "Selected".
  - The app enters "Selection Mode".
  - **Type Locking:** The `type` (Domestic/International) of the *first* selected order locks the selection.
    - If the first order is "Domestic", all "International" orders become **disabled** (greyed out/non-selectable).
    - Vice-versa for "International".

### Visual Changes (Selection Mode)
- **Selected Card:**
  - Border: `2px` solid `primary.500`.
  - Icon: Leading checkbox (checked) or overlay tick.
  - Background: `primary.50` (light tint).
- **Unselected Card:** 
  - Visual: Normal card.
  - Action: Tap to select.
- **Disabled Card (Wrong Type):**
  - Opacity: `0.5`.
  - Action: None (or toast message "Cannot mix Domestic & International").

### Sticky Action Bar (Bottom)
- **Appearance:** 
  - Floating bar or fixed bottom sheet.
  - Background: `primary.dark` (`#022B4A`).
  - Font Color: White.
- **Content:**
  - **Left:** 
    - "3 Orders Selected" (Bold).
    - "Total Weight: 15.5 KG" (Caption).
  - **Right:** 
    - **"Book Now" Button** (White/Warning Color).
- **Action:** 
  - Tap "Book Now" -> Navigate to `BulkBookingSummaryScreen`.
- **Exit:** 
  - Tap "X" (Close selection mode) or Back button.

