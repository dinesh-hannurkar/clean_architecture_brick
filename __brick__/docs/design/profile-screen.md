# Profile Screen UI Specifications

**Version:** 1.0.0
**Status:** Draft
**Designer:** UI/UX Designer

---

## 1. Overview
The Profile screen serves as the user's account management hub. It displays personal/business information, account settings, and provides access to legal documentation and logout functionality.

---

## 2. Layout Structure

### A. App Bar (Top)
- **Background:** Linear Gradient (`primary` to `primaryDark`).
- **Leading:** Back arrow (White).
- **Title:** "Profile".
- **Actions:** None.

### B. Header Section (User Info)
- **Background:** Primary Gradient or Flat Primary Color (extends slightly from App Bar).
- **Content:**
  - **Avatar:** Large circular avatar (`80x80dp`). White border. Placeholder icon or user photo.
  - **Name:** `h6` (20px, Bold), Color: White.
  - **Subtitle:** User role or company name (e.g., "App Logistics Admin"), Color: White (80% opacity).

### C. Content Body (Scrollable)
- **Background:** `neutral.100` (`#F5F5F5`).
- **Grouping:** Use distinct cards or sections with headers for better organization.

---

## 3. Sections & Data Points

### Section 1: Business Details
- **Card-based layout.**
- **Fields:**
  - Company Name
  - GST Number
  - Registered Address
  - Primary Mobile
  - Email Address

### Section 2: Account Settings
- **List-style items** with trailing icons.
- **Actions:**
  - **Change Password:** Tap to navigate to reset flow.
  - **Notification Settings:** Toggle for push notifications.
  - **Language:** Dropdown selection.

### Section 3: Information & Support
- **List-style items.**
- **Links:**
  - Rate Calculator
  - Privacy Policy
  - Terms & Conditions
  - About App
  - Contact Support / FAQ

### Section 4: Actions (Logout)
- **Logout Button:**
  - Style: Outlined or Text button with destructive red color.
  - Icon: `logout` (prefix).
  - Confirmation: Show dialog on tap.

---

## 4. UI Components & Styling

### List Items
- **Prefix Icon:** Color: `primary.500`, Size: `24dp`.
- **Title:** `subtitle1` (16px, Medium weight), Color: `textPrimary`.
- **Trailing:** `chevron_right` icon, Color: `neutral.400`.
- **Padding:** `horizontal: 16dp, vertical: 12dp`.

### Section Headers
- **Typography:** `overline` or `caption` (12px, Bold/Uppercase).
- **Color:** `neutral.600`.
- **Padding:** `horizontal: 16dp, top: 24dp, bottom: 8dp`.

---

## 5. Interaction Guidelines

- **Editing:** Fields in "Business Details" are typically read-only in the main view. Add an "Edit" icon/button in the section header to enter edit mode.
- **Logout Flow:**
  - On tap -> Show Material Alert Dialog ("Log out of App?").
  - On confirm -> Clear secure storage -> Navigate to Login Screen.

---
