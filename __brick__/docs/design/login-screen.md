# Login Screen UI Specifications

**Version:** 1.0.0
**Status:** Approved for Implementation
**Designer:** UI/UX Designer

---

## 1. Overview
A premium, trustworthy, and high-app entry point for the application. The login screen must support three distinct authentication methods while maintaining a clean and un-cluttered interface.

**Core Requirements:**
- **Visuals:** Highly attractive, immersive gradient background, centered card layout.
- **Branding:** Prominent use of the App Logo.
- **Auth Methods:**
  1. Username + Password
  2. Mobile Number + OTP
  3. Google Sign-In

---

## 2. Visual Style & Layout

### Background
- **Style:** Immersive Linear Gradient.
- **Colors:**
  - Top-Left: `#0467B0` (Primary 500)
  - Bottom-Right: `#022B4A` (Dark Brand Blue)
- **Effect:** Create a feeling of depth and security. The content floats above this background.

### Layout Container (The Card)
- **Shape:** Rounded Rectangular Card.
- **Color:** White (`#FFFFFF`) / Dark Surface (`#1E1E1E` in Dark Mode).
- **Elevation:** `shadow_xxl` (24dp) - High elevation to separate from gradient.
- **Border Radius:** `xl` (16dp).
- **Margin:** `lg` (24dp) horizontal margin (never touches screen edges).
- **Padding:** `lg` (24dp) to `xl` (32dp).
- **Position:** Center of the screen (vertically and horizontally).

### Assets
- **Logo:** `docs/assets/app-logo.png`
- **Size:** Height ~64dp.
- **Placement:** Top center of the Card.

---

## 3. UI Component Structure

### Header Section (Inside Card)
1.  **Logo:** Centered.
2.  **Spacer:** `16dp`.
3.  **Title:** "Welcome Back"
    -   Style: `h5` (Headline 5), Bold.
    -   Color: `textPrimary`.
    -   Alignment: Center.
4.  **Subtitle:** "Sign in to continue to App"
    -   Style: `body2`.
    -   Color: `textSecondary`.
    -   Alignment: Center.

### Authentication Toggle (The Switch)
To avoid cluttering the UI with too many fields at once, use a **Sliding Segmented Control** or **Tab Bar** to switch between methods.

-   **Tabs:** "Password" | "OTP"
-   **Style:** Pill-shaped indicator, high contrast active state.
-   **Transition:** Smooth fade/slide animation when switching forms.

### Form Section A: Password (Default)
1.  **Username/Email Input:**
    -   Label: "Email or Username"
    -   Icon prefix: `person_outline` or `email_outlined`.
2.  **Password Input:**
    -   Label: "Password"
    -   Icon prefix: `lock_outlined`.
    -   Icon suffix: `visibility_off` (toggle).
3.  **Forgot Password:**
    -   Right-aligned text link.
    -   Style: `caption`, Color: `primary.500`.

### Form Section B: OTP (Alternative)
1.  **Phone Input:**
    -   Label: "Mobile Number"
    -   Icon prefix: `phone_android`.
2.  **Action:** "Get OTP" (Small text button or auto-trigger).
3.  **OTP Input:**
    -   Visible only after sending.
    -   Pill-shaped input boxes (4 or 6 digits).

### Primary Action
-   **Button:** "Sign In"
-   **Style:** Full width, Primary Color, `height: 48dp`, `radius: 8dp`.
-   **State:** Disabled if inputs are invalid.

### Social Section
1.  **Divider:** "Or continue with" (Line - Text - Line).
2.  **Google Button:**
    -   Style: Outlined or Secondary Surface.
    -   Icon: Official Google "G" logo (color).
    -   Text: "Sign in with Google".
    -   Width: Full width.

---

## 4. Interaction & Motion Guidelines

-   **Entry Animation:**
    -   The Background fades in first.
    -   The Card slides up slightly (`50dp` -> `0dp`) and fades in (`duration: 500ms`, `curve: fastOutSlowIn`).
-   **Input Focus:**
    -   Field border changes from `neutral.300` to `primary.500`.
    -   Label scales down and moves up (Material standard).
-   **Tab Switch:**
    -   Animated size change if height differs.
    -   Crossfade fields.

## 5. Accessibility Requirements
-   All inputs must have `autofillHints`.
-   Keyboard type must match input (e.g., `TextInputType.emailAddress`, `TextInputType.phone`).
-   The "Sign In" button must be keyboard accessible (Enter key).
-   Contrast checks pass for white text on the blue gradient (Status Bar text should be White).
