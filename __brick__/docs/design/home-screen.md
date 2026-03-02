# Home Screen UI Specifications

**Version:** 1.0.0
**Status:** In Progress
**Designer:** UI/UX Designer

---

## 1. Overview
The Home Screen serves as the main dashboard for the logistics/shipping workflow. It features a branded App Bar and a persistent Bottom Navigation bar to switch between active workflows ("To Ship") and historical data ("History").

**Reference:** `uploaded_image_1769505959753.png`

---

## 2. Layout Structure

### A. App Bar (Top)
A custom branded app bar distinct from the standard Material design.

- **Background:** Linear Gradient (Top-Center to Bottom-Center or Left to Right).
  - Colors: `AppColors.primary` (#0467B0) to `AppColors.primaryDark` (#022B4A).
  - Effect: Adds depth and premium feel, matching the Login screen aesthetic.
- **Height:** `56dp` (Standard).
- **Content:**
  1.  **Leading/Title:**
      -   **App Logo** (White/Negative version).
      -   Asset: `docs/assets/app_logo_white.png` (Assumed) or Text "app" in white custom font with "Accelerating Efficiency" tagline if logo is text-based.
      -   Alignment: Left aligned.
  2.  **Actions (Right):**
      -   **Profile Icon:**
          -   Icon: `account_circle` (Material).
          -   Color: White (`#FFFFFF`).
          -   Size: `28dp`.
          -   Action: Opens Profile/Settings.

### B. Bottom Navigation (Bottom)
Persistent navigation bar for top-level views.

- **Background:** White (`#FFFFFF`).
- **Elevation:** `shadow_lg` (8dp) - subtle shadow at the top.
- **Height:** `Standard BottomNavigationBar` (approx 56-80dp).
- **Items:**
  1.  **To Ship** (Default Selected)
      -   Icon: `shopping_basket` or `inventory` (looks like a bin/basket).
      -   Label: "To Ship".
  2.  **History**
      -   Icon: `history` or `schedule` (looks like box with clock).
      -   Label: "History".
- **States:**
  -   **Selected:**
      -   Icon Color: `primary.500` (`#0467B0`).
      -   Text Color: `primary.500` (`#0467B0`).
      -   Text Style: `caption` (Bold/Medium).
  -   **Unselected:**
      -   Icon Color: `neutral.900` (`#212121`) or `neutral.600`.
      -   Text Color: `neutral.900` (`#212121`).
      -   Text Style: `caption` (Regular).

### C. Body Content (Middle)
Placeholder for now, but referenced relative to the screenshot.

- **Header:** "Shopify Orders" (Headline).
- **Sub-header:** "Last Sync [Time]" + Sync Icon.
- **List:** Order cards (Domestic/International labels, Customer Name, Location, Items/Weight).

---

## 3. Implementation Guide (Frontend)

### Structure
Use a `Scaffold` structure:

```dart
Scaffold(
  appBar: AppAppBar(), // Custom Widget
  body: _screens[_currentIndex],
  bottomNavigationBar: AppBottomNav(
    currentIndex: _currentIndex,
    onTap: (index) => ...
  ),
)
```

### Assets Needed
-   **Header Logo:** Ensure we have a high-res white version of the logo for the blue background.
-   **Icons:** Use standard `Icons.inventory_2_outlined` or similar if custom SVG not provided yet.

---

## 4. Colors & Theme
-   **App Bar BG:** `AppColors.primary`
-   **App Bar Content:** `AppColors.onPrimary`
-   **Bottom Nav BG:** `AppColors.surface`
-   **Bottom Nav Selected:** `AppColors.primary`
-   **Bottom Nav Unselected:** `AppColors.textPrimary` (High contrast, nearly black).

---
