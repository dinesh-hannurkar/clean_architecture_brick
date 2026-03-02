# Design System - Project App

**Version:** 1.0.0  
**Last Updated:** 2026-01-23  
**Owner:** UI/UX Designer

---

## Overview

This design system establishes the visual language and interaction patterns for Project App. It ensures consistency, accessibility, and scalability across the entire mobile application.

### Design Philosophy

- **Clean & Minimal:** Reduce cognitive load with clear visual hierarchy
- **Accessible by Default:** WCAG 2.1 AA compliance minimum
- **Platform Adaptive:** Respect Material Design (Android) and Cupertino (iOS) guidelines
- **Performant:** Optimize animations and asset usage
- **Scalable:** Design tokens enable theme switching and future customization

---

## Color System

### Primary Palette

Our primary color is a modern, vibrant blue that conveys trust, innovation, and app.

```yaml
primary:
  50:  '#E3F2FD'   # Lightest tint
  100: '#BBDEFB'
  200: '#90CAF9'
  300: '#64B5F6'
  400: '#42A5F5'
  500: '#2196F3'   # Primary brand color
  600: '#1E88E5'
  700: '#1976D2'   # Primary dark
  800: '#1565C0'
  900: '#0D47A1'   # Darkest shade
```

### Secondary Palette

Complementary teal for accents and secondary actions.

```yaml
secondary:
  50:  '#E0F2F1'
  100: '#B2DFDB'
  200: '#80CBC4'
  300: '#4DB6AC'
  400: '#26A69A'
  500: '#009688'   # Secondary brand color
  600: '#00897B'
  700: '#00796B'   # Secondary dark
  800: '#00695C'
  900: '#004D40'
```

### Semantic Colors

Purpose-driven colors for feedback and state communication.

```yaml
success:
  light:  '#81C784'
  main:   '#4CAF50'
  dark:   '#388E3C'
  
error:
  light:  '#E57373'
  main:   '#F44336'
  dark:   '#D32F2F'
  
warning:
  light:  '#FFB74D'
  main:   '#FF9800'
  dark:   '#F57C00'
  
info:
  light:  '#64B5F6'
  main:   '#2196F3'
  dark:   '#1976D2'
```

### Neutral Palette

Grayscale for text, borders, backgrounds, and surfaces.

```yaml
neutral:
  0:   '#FFFFFF'   # Pure white
  50:  '#FAFAFA'   # Surface
  100: '#F5F5F5'   # Background
  200: '#EEEEEE'   # Divider light
  300: '#E0E0E0'   # Border
  400: '#BDBDBD'   # Disabled
  500: '#9E9E9E'   # Text secondary
  600: '#757575'   # Text tertiary
  700: '#616161'   # Text primary (on light)
  800: '#424242'   # Surface dark
  900: '#212121'   # Background dark
  1000: '#000000'  # Pure black
```

### Text on Color

Contrast ratios meet WCAG 2.1 AA standards (4.5:1 minimum).

```yaml
on_primary: '#FFFFFF'        # White text on primary
on_secondary: '#FFFFFF'      # White text on secondary
on_success: '#FFFFFF'
on_error: '#FFFFFF'
on_warning: '#000000'        # Black text on warning (better contrast)
on_surface: '#212121'        # Dark text on light surface
on_background: '#212121'
```

### Dark Mode

```yaml
dark_theme:
  surface: '#121212'          # Base surface
  surface_1dp: '#1E1E1E'      # Elevated +1dp
  surface_2dp: '#232323'      # Elevated +2dp
  surface_4dp: '#272727'      # Elevated +4dp
  surface_6dp: '#2C2C2C'      # Elevated +6dp
  surface_8dp: '#2F2F2F'      # Elevated +8dp
  
  on_surface: '#FFFFFF'
  on_background: '#FFFFFF'
  
  primary: '#90CAF9'          # Lighter primary for dark mode
  secondary: '#80CBC4'        # Lighter secondary for dark mode
```

---

## Typography

### Font Family

**Primary:** [Roboto](https://fonts.google.com/specimen/Roboto) (Material Design standard)  
**Fallback:** System default sans-serif

```dart
// Flutter implementation
fontFamily: 'Roboto'
```

### Type Scale

Following Material Design type scale with modular scale ratio of 1.250 (Major Third).

| Token | Font Size | Line Height | Font Weight | Letter Spacing | Use Case |
|-------|-----------|-------------|-------------|----------------|----------|
| **h1** | 96px | 112px | 300 (Light) | -1.5px | Hero headlines (rare) |
| **h2** | 60px | 72px | 300 (Light) | -0.5px | Page titles |
| **h3** | 48px | 56px | 400 (Regular) | 0px | Section headers |
| **h4** | 34px | 40px | 400 (Regular) | 0.25px | Sub-section headers |
| **h5** | 24px | 32px | 400 (Regular) | 0px | Card titles |
| **h6** | 20px | 28px | 500 (Medium) | 0.15px | List item headers |
| **subtitle1** | 16px | 24px | 400 (Regular) | 0.15px | Subtitles, captions |
| **subtitle2** | 14px | 20px | 500 (Medium) | 0.1px | Dense subtitles |
| **body1** | 16px | 24px | 400 (Regular) | 0.5px | Primary body text |
| **body2** | 14px | 20px | 400 (Regular) | 0.25px | Secondary body text |
| **button** | 14px | 16px | 500 (Medium) | 1.25px | Button labels (ALL CAPS) |
| **caption** | 12px | 16px | 400 (Regular) | 0.4px | Helper text, timestamps |
| **overline** | 10px | 16px | 400 (Regular) | 1.5px | Overline labels (ALL CAPS) |

### Accessibility

- **Minimum body text size:** 14px (except captions)
- **Minimum touch target text:** 16px for tappable elements
- **Line height:** Minimum 1.5x font size for body text
- **Contrast:** All text meets WCAG AA (4.5:1 body, 3:1 large text)

---

## Spacing System

8-point grid system for consistent rhythm and alignment.

### Base Unit

```dart
const double baseUnit = 8.0;
```

### Spacing Scale

| Token | Value | Flutter Constant | Use Case |
|-------|-------|------------------|----------|
| **xxs** | 2px | `0.25 * baseUnit` | Compact gaps, fine adjustments |
| **xs** | 4px | `0.5 * baseUnit` | Tight spacing within components |
| **sm** | 8px | `1.0 * baseUnit` | Component internal padding |
| **md** | 16px | `2.0 * baseUnit` | Default spacing between elements |
| **lg** | 24px | `3.0 * baseUnit` | Section spacing |
| **xl** | 32px | `4.0 * baseUnit` | Large separation |
| **xxl** | 48px | `6.0 * baseUnit` | Major section breaks |
| **xxxl** | 64px | `8.0 * baseUnit` | Screen-level margins |

### Screen Margins

```yaml
mobile_portrait:
  horizontal: 16px  # md
  vertical: 16px    # md
  
mobile_landscape:
  horizontal: 24px  # lg
  vertical: 16px    # md
  
tablet:
  horizontal: 24px  # lg
  vertical: 24px    # lg
```

---

## Elevation & Shadows

Material Design elevation system (0dp to 24dp).

```yaml
shadow_none: elevation 0dp
shadow_sm:   elevation 2dp   # Cards at rest
shadow_md:   elevation 4dp   # App bar, raised buttons
shadow_lg:   elevation 8dp   # Dialogs, pickers
shadow_xl:   elevation 16dp  # Navigation drawer
shadow_xxl:  elevation 24dp  # Modal bottom sheets
```

**Implementation in Flutter:**
```dart
elevation: 2.0  // Applies Material shadow automatically
```

---

## Border Radius

Rounded corners for approachability and modern aesthetics.

| Token | Value | Use Case |
|-------|-------|----------|
| **none** | 0px | Alerts, full-bleed images |
| **sm** | 4px | Small chips, tags |
| **md** | 8px | Default cards, buttons |
| **lg** | 12px | Large cards, dialogs |
| **xl** | 16px | Bottom sheets, modals |
| **pill** | 999px | Pill-shaped buttons, badges |
| **circle** | 50% | Avatar, icon buttons |

---

## Iconography

### Icon System

**Library:** [Material Icons](https://fonts.google.com/icons) (default Flutter icons)  
**Style:** Outlined (primary), Filled (selected states), Rounded (friendly contexts)

### Icon Sizes

| Token | Size | Use Case |
|-------|------|----------|
| **xs** | 16px | Inline with text |
| **sm** | 20px | Compact lists |
| **md** | 24px | Default buttons, app bar |
| **lg** | 32px | Prominent actions |
| **xl** | 48px | Feature highlights |
| **xxl** | 64px | Empty states, onboarding |

### Icon Colors

```yaml
primary_icon: neutral.700      # Default icons on light background
secondary_icon: neutral.500    # Less prominent icons
disabled_icon: neutral.400     # Disabled state
inverse_icon: neutral.0        # Icons on dark/colored backgrounds
```

### Accessibility

- **Touch targets:** Minimum 48x48px tappable area (even if icon is smaller)
- **Semantic meaning:** Never rely solely on color; include labels or tooltips
- **Contrast:** Minimum 3:1 against background

---

## Animation & Motion

### Principles

1. **Purposeful:** Every animation must serve a functional purpose (feedback, continuity, hierarchy)
2. **Responsive:** Immediate feedback (< 100ms) for interactions
3. **Natural:** Ease-in-out curves mimic real-world physics
4. **Performant:** Avoid jank; use `Transform` and `Opacity` for GPU-accelerated animations

### Duration Scale

| Token | Duration | Use Case |
|-------|----------|----------|
| **instant** | 0ms | State changes (no animation) |
| **immediate** | 100ms | Micro-interactions (ripple, toggle) |
| **quick** | 200ms | Small components (button, chip) |
| **normal** | 300ms | Default transitions (page, modal) |
| **moderate** | 500ms | Complex transitions (hero animations) |
| **slow** | 700ms | Emphasis animations (onboarding) |

### Easing Curves

```dart
// Material Design standard curves
Curves.easeInOut    // Default for most transitions
Curves.easeOut      // Entering elements (0 -> 100%)
Curves.easeIn       // Exiting elements (100% -> 0)
Curves.fastOutSlowIn // Emphasized entrance (Material standard)
Curves.decelerate   // Scroll physics, fling
```

### Common Patterns

**Page Transitions:**
```dart
duration: Duration(milliseconds: 300)
curve: Curves.fastOutSlowIn
```

**Micro-interactions (button press):**
```dart
duration: Duration(milliseconds: 100)
curve: Curves.easeOut
```

**Bottom Sheet Slide:**
```dart
duration: Duration(milliseconds: 250)
curve: Curves.easeOut
```

### Accessibility

- **Respect user preferences:** Check `MediaQuery.of(context).disableAnimations`
- **Reduce motion:** Provide option to disable non-essential animations

---

## Component Design Tokens

### Buttons

#### Primary Button
```yaml
height: 48px
min_width: 88px
padding_horizontal: 24px
border_radius: md (8px)
elevation: 2dp (resting), 8dp (pressed)
background: primary.500
text: button style, on_primary color
ripple_color: on_primary with 24% opacity
```

#### Secondary Button (Outlined)
```yaml
height: 48px
min_width: 88px
padding_horizontal: 24px
border_radius: md (8px)
border: 1px solid primary.500
background: transparent
text: button style, primary.500 color
ripple_color: primary with 12% opacity
```

#### Text Button
```yaml
height: 48px
min_width: 64px
padding_horizontal: 16px
border_radius: md (8px)
background: transparent
text: button style, primary.500 color
ripple_color: primary with 12% opacity
```

### Cards

```yaml
padding: 16px (md)
border_radius: lg (12px)
elevation: sm (2dp)
background: surface (light mode) or surface_2dp (dark mode)
border: none (elevation provides separation)
```

### Input Fields

```yaml
height: 56px
padding_horizontal: 16px
border_radius: sm (4px)
border: 1px solid neutral.300 (unfocused), 2px primary.500 (focused)
label: body2, neutral.600 (floating label)
error_state: error.main border, error.main label
helper_text: caption, neutral.500
```

### App Bar

```yaml
height: 56px (mobile), 64px (tablet)
elevation: md (4dp)
background: primary.500 (light mode), surface_8dp (dark mode)
title: h6 style, on_primary color
icons: 24px, on_primary color
icon_touch_target: 48x48px
```

### Bottom Navigation

```yaml
height: 56px
elevation: lg (8dp)
background: surface (light), surface_8dp (dark)
item_count: 3-5 items
icon_size: 24px
label: caption style
selected_color: primary.500
unselected_color: neutral.500
```

### Dialogs

```yaml
min_width: 280px
max_width: 560px
padding: 24px
border_radius: xl (16px)
elevation: xxl (24dp)
background: surface
title: h6 style, on_surface
body: body1 style, on_surface
actions_padding: 8px
```

---

## Accessibility Guidelines

### WCAG 2.1 AA Compliance

✅ **Color Contrast**
- Normal text (< 18px): Minimum 4.5:1
- Large text (≥ 18px or ≥ 14px bold): Minimum 3:1
- UI components: Minimum 3:1

✅ **Touch Targets**
- Minimum size: 48x48 dp (Material Design standard)
- Spacing between targets: Minimum 8dp

✅ **Text Sizing**
- Support dynamic type (user font size preferences)
- Minimum body text: 14px
- Scalable up to 200% without loss of content

✅ **Semantic Structure**
- Proper heading hierarchy (h1 → h2 → h3...)
- Landmark regions for screen readers
- Descriptive labels for interactive elements

✅ **Focus Indicators**
- Visible focus state for keyboard navigation
- Focus order follows logical reading flow (top-to-bottom, left-to-right)

✅ **Motion & Animation**
- Respect `prefers-reduced-motion`
- No flashing content (seizure risk: > 3 flashes/second)

### Screen Reader Support

- Use semantic widgets (`Semantics` in Flutter)
- Provide alternative text for images
- Announce dynamic content changes
- Logical focus traversal order

---

## Design Token Reference

### Flutter Implementation

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF90CAF9);
  
  // Secondary
  static const Color secondary = Color(0xFF009688);
  static const Color secondaryDark = Color(0xFF00796B);
  static const Color secondaryLight = Color(0xFF80CBC4);
  
  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Neutral
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
}

class AppSpacing {
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

class AppBorderRadius {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double pill = 999.0;
}

class AppElevation {
  static const double none = 0.0;
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
}

class AppDurations {
  static const Duration instant = Duration.zero;
  static const Duration immediate = Duration(milliseconds: 100);
  static const Duration quick = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration moderate = Duration(milliseconds: 500);
  static const Duration slow = Duration(milliseconds: 700);
}
```

---

## Usage Guidelines

### DO ✅

- Use design tokens consistently throughout the app
- Follow Material Design guidelines for platform conventions
- Test with different font sizes and accessibility settings
- Provide loading, error, and empty states for all UI
- Use semantic colors (success, error, warning) appropriately
- Maintain 8dp grid alignment

### DON'T ❌

- Hardcode color values or spacing in components
- Create custom widgets without using design tokens
- Rely solely on color to convey information
- Use touch targets smaller than 48x48dp
- Override system font size preferences
- Create non-responsive layouts

---

## Figma Library

*Note: Physical Figma files will be maintained separately. This documentation serves as the source of truth for implementation.*

**Recommended Figma Structure:**
```
📁 App Design System
  ├─ 📄 01_Foundation (Colors, Typography, Spacing)
  ├─ 📄 02_Components (Buttons, Cards, Inputs)
  ├─ 📄 03_Patterns (Navigation, Dialogs, Empty States)
  └─ 📄 04_Templates (Screens with auto-layout)
```

---

## Versioning

**Current Version:** 1.0.0

### Changelog

**v1.0.0 (2026-01-23)**
- Initial design system establishment
- Color palette, typography, spacing defined
- Component tokens documented
- Accessibility guidelines established
- Flutter implementation reference created

---

## Next Steps

1. **Frontend Developer:** Implement design tokens in `lib/core/theme/`
2. **Create Figma library** with all components (if Figma is part of workflow)
3. **Design authentication screens** using this system
4. **Create pattern library** for common UI patterns (forms, lists, empty states)
5. **Establish icon asset pipeline** (export process, naming conventions)

---

**Document Owner:** UI/UX Designer  
**Last Review:** 2026-01-23  
**Status:** ✅ Complete
