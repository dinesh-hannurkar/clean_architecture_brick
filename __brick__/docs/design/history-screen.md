# History Screen UI Specifications

**Version:** 1.0.0
**Status:** Ready for Implementation
**Designer:** UI/UX Designer

---

## 1. Overview
The History screen displays a record of past shipping orders. Unlike the "To Ship" screen, it uses a **Top Tab Bar** to segment orders into "Domestic" and "International" categories, allowing for easier navigation through large datasets.

**Reference:** `uploaded_image_1769510386247.png`

---

## 2. Layout Structure

### A. Segmented Tab Bar (Top)
Replaces the title bar section. Positioned immediately below the branded App Bar.

**Layout:**
- **Background:** White (`#FFFFFF`)
- **Height:** `48dp`
- **Border Bottom:** 1px solid `neutral.200` (`#EEEEEE`)

**Tabs:**
1.  **Domestic**
2.  **International**

**Selected State:**
- **Text Color:** `primary.500` (`#0467B0`)
- **Font Weight:** Bold/Medium
- **Indicator:** 2dp high horizontal bar at the bottom of the tab, colored `primary.500`.

**Unselected State:**
- **Text Color:** `neutral.900` (`#212121`)
- **Font Weight:** Regular
- **Indicator:** None (transparent)

### B. Order List Section
Displays historical order cards filtered by the active tab.

**Container:**
- **Background:** `neutral.100` (`#F5F5F5`)
- **Padding:** `horizontal: 16dp, top: 8dp, bottom: 8dp`
- **Component:** Uses the standardized `OrderCard` widget.

---

## 3. Implementation Guide (Flutter)

Utilize `DefaultTabController` and `TabBar` for a native, performant experience.

```dart
DefaultTabController(
  length: 2,
  child: Scaffold(
    appBar: AppAppBar(
      // The TabBar can be part of the AppBar bottom or a standalone container
      bottom: TabBar(
        indicatorColor: AppColors.primary,
        indicatorWeight: 3.0,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.onSurface,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'Domestic'),
          Tab(text: 'International'),
        ],
      ),
    ),
    body: TabBarView(
      children: [
        HistoryList(type: ShippingType.domestic),
        HistoryList(type: ShippingType.international),
      ],
    ),
  ),
)
```

**Style Overrides:**
- Ensure the `TabBar` indicator spans the full width of the tab or follows the text width as per the screenshot (looks like it follows a fixed padding).
- Remove the shadow between the App Bar and Tab Bar to make them feel like a single unit.

---

## 4. Interaction Patterns

- **Swipe Navigation:** Users should be able to swipe left/right between Domestic and International lists.
- **Tab Tap:** Immediate jump to the respective list.
- **Filtering:** Tapping a tab triggers a filter on the underlying historical data set.

---

## 5. Implementation Notes

1.  **State Management:** The `HistoryBloc` should handle fetching orders for both categories, potentially caching them to make tab switching instantaneous.
2.  **Reusable Components:** Ensure the `OrderCard` is used to maintain visual consistency across "To Ship" and "History" screens.
3.  **Empty State:** If a category has no history, show the "No History Found" empty state with an appropriate icon.

---
