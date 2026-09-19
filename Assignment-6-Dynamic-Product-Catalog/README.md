# 💎 LUXE MART — Dynamic Product Catalog Mobile Application

A premium, modern Gen-Z e-commerce mobile application built with **Flutter & Dart** demonstrating dynamic data modeling, reactive state management with `setState()`, list rendering with `ListView.builder`, and real-time multi-criteria search and category filtering.

Developed for **Assignment 6: Dynamic Product Catalog**.

---

## 📸 App Screenshots

| 01. Splash Screen | 02. Home / Catalog | 03. Wishlist |
| :---: | :---: | :---: |
| <img src="screenshots/01_splash_screen.png" width="260" /> | <img src="screenshots/02_home_screen.png" width="260" /> | <img src="screenshots/03_wishlist_screen.png" width="260" /> |

| 04. Cart & Checkout | 05. User Profile |
| :---: | :---: |
| <img src="screenshots/04_cart_screen.png" width="260" /> | <img src="screenshots/05_profile_screen.png" width="260" /> |

---

## 🌟 Key Features

### 1. 💫 Animated Splash Screen
- Golden diamond emblem with multi-layered gradient styling.
- Smooth scale & fade micro-animations.
- Automatic navigation to the catalog after 2.4 seconds with a subtle fade transition.

### 2. 🛍️ Dynamic Product Catalog
- Rendered using dynamic builder widgets (`ListView.builder` / `SliverGrid.builder`).
- Displays 13 realistic items across 5 core categories (**Electronics, Fashion, Shoes, Accessories, Beauty**).
- Dynamic product cards featuring product image, title, category badge, rating with review count, price, heart icon, and add-to-cart button.
- Smooth scale-down press feedback on tap.

### 3. 🔍 Real-Time Search Functionality
- Powered by `TextField` and its `onChanged` callback.
- Case-insensitive search across both product names and category names.
- Instant UI update via `setState()`.
- Interactive clear button (`✕`) when text is present.
- Live badge displaying matching product count.

### 4. 🏷️ Category Filter Chips
- Horizontal scrolling pill chips: *All, Electronics, Fashion, Shoes, Accessories, Beauty*.
- Active gold pill highlight with soft elevation.
- Seamlessly combines with the search bar (**AND logic**): searching `"pro"` while selecting `"Electronics"` displays only electronic products containing `"pro"`.

### 5. 📖 Product Details Screen
- Smooth **Hero Animation** transitions the product image from catalog to details.
- Available color/variant selector chips.
- Quantity selector stepper (`+` / `-`).
- Sticky bottom bar showing live calculated total price and an animated "Add to Cart" button.

### 6. ❤️ Functional Wishlist
- Heart button toggles save/remove state dynamically.
- Synchronized red badge count in bottom navigation bar.
- Dedicated Wishlist screen with instant removal and quick "Add to Cart".
- Helpful custom empty state when no items are saved.

### 7. 🛒 Interactive Cart & Checkout
- Quantity stepper controls (`+` / `-`) for each cart item with live price updates.
- One-tap removal with trash icon.
- Order summary displaying Subtotal, 10% promotional discount, and Grand Total.
- Animated checkout action with confirmation SnackBar notification.
- Cart count badge reflected in real-time across navigation bar.

### 8. 👤 User Profile Screen
- Designed for **Sahil Pandey** (`sahil@luxemart.com`).
- Metrics dashboard: Orders (12), Wishlist (5), Reviews (2).
- Sectional list for Orders, Addresses, Payment Methods, Notifications, Settings, and Logout.

### 9. 🎨 Empty States
- Elegant empty state illustrations for zero search results, empty wishlist, and empty cart.
- Includes descriptive feedback and one-tap action buttons (e.g. "Clear Filters").

---

## 🏛️ Core Assignment Architecture

The application strictly implements the required assignment flow without hiding logic behind third-party state libraries:

```
                  ┌────────────────────────────────────────┐
                  │          Product Data Model            │
                  │        (lib/models/product.dart)       │
                  └──────────────────┬─────────────────────┘
                                     │
                                     ▼
                  ┌────────────────────────────────────────┐
                  │       List<Product> sampleProducts     │
                  │        (lib/data/products.dart)        │
                  └──────────────────┬─────────────────────┘
                                     │
                                     ▼
                  ┌────────────────────────────────────────┐
                  │      List<Product> _filteredProducts   │
                  │        (lib/screens/home_screen.dart)  │
                  └──────────────────┬─────────────────────┘
                                     │
                                     ▼
         ┌───────────────────────────┴───────────────────────────┐
         │                                                       │
         ▼                                                       ▼
┌──────────────────┐                                   ┌──────────────────┐
│ TextField.onChanged                                  │ CategoryChip.onTap│
└────────┬─────────┘                                   └────────┬─────────┘
         │                                                       │
         └───────────────────────────┬───────────────────────────┘
                                     │
                                     ▼
                  ┌────────────────────────────────────────┐
                  │            setState()                  │
                  │   re-runs filter & updates widget tree │
                  └──────────────────┬─────────────────────┘
                                     │
                                     ▼
                  ┌────────────────────────────────────────┐
                  │          ListView.builder              │
                  │  efficient visible-item rendering      │
                  └────────────────────────────────────────┘
```

### Why these concepts are used:
1. **`Product` Model**: Provides strict type safety, prevents runtime typing errors, and provides autocomplete for properties like `price`, `rating`, and `category`.
2. **`List<Product>`**: Acts as an in-memory database of items. `sampleProducts` remains immutable, while `_filteredProducts` is derived based on user query.
3. **`ListView.builder`**: Renders items lazily on demand. Unlike static columns, it recycles off-screen widgets to guarantee high frame rates and low memory consumption.
4. **`setState()`**: The fundamental Flutter mechanism to signal the framework that state has changed, triggering a targeted re-render of the widget tree.

---

## 📁 Project Directory Structure

```
lib/
├── main.dart                       # App entry point, system overlays & theme setup
├── models/
│   └── product.dart                # Strongly-typed Product model
├── data/
│   └── products.dart               # 13 sample products with local asset paths
├── theme/
│   └── app_theme.dart              # Material 3 luxury gold & charcoal palette
├── screens/
│   ├── splash_screen.dart          # Animated splash screen
│   ├── main_shell.dart             # Bottom navigation & lifted state management
│   ├── home_screen.dart            # Product catalog, search bar & category filters
│   ├── product_details_screen.dart # Detail screen with Hero animation & options
│   ├── wishlist_screen.dart        # Saved items with empty state
│   ├── cart_screen.dart            # Cart with quantity steppers & checkout summary
│   └── profile_screen.dart         # User profile screen for Sahil
└── widgets/
    ├── product_card.dart           # Interactive product card widget
    ├── product_image.dart          # Smart asset/network image loader with fallback
    ├── category_chip.dart          # Category filter chip
    └── empty_state.dart            # Custom empty state placeholder widget
assets/
└── images/                         # 13 high-resolution bundled product photos
screenshots/
├── 01_splash_screen.png
├── 02_home_screen.png
├── 03_wishlist_screen.png
├── 04_cart_screen.png
└── 05_profile_screen.png
test/
└── widget_test.dart                # Automated unit and widget tests
```

---

## 🎨 Design System & Color Palette

| Token | Hex | Preview | Usage |
| :--- | :--- | :--- | :--- |
| **Gold Accent** | `#C9A84C` | 🟡 | Primary buttons, active tabs, stars, badges |
| **Gold Light** | `#E8D08A` | 🟡 | Gradient accents & icon borders |
| **Deep Charcoal** | `#1A1A2E` | ⚫ | Headings, splash background, contrast cards |
| **Off-White Canvas** | `#F7F6F3` | ⚪ | Main application background |
| **Pure White** | `#FFFFFF` | ⚪ | Cards, search bar, and navigation surface |
| **Wishlist Red** | `#E53935` | 🔴 | Wishlist heart indicators & badge counters |
| **Success Green** | `#43A047` | 🟢 | Added-to-cart & discount values |

---

## 🚀 Getting Started & Running

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.22+ recommended)
- [Dart SDK](https://dart.dev/get-dart) (3.4+ recommended)
- Chrome browser, Android Studio / Emulator, or macOS

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Sahilp2407/Assignment-6-Dynamic-Product-Catalog.git
   cd Assignment-6-Dynamic-Product-Catalog
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify code quality:**
   ```bash
   flutter analyze
   # Output: No issues found!
   ```

4. **Run automated test suite:**
   ```bash
   flutter test
   # Output: All tests passed!
   ```

5. **Launch application:**
   - On **Chrome**:
     ```bash
     flutter run -d chrome
     ```
   - On **macOS Desktop**:
     ```bash
     flutter run -d macos
     ```
   - On **Android Device / Emulator**:
     ```bash
     flutter run
     ```

---

## 👨‍💻 Author

- **Sahil Pandey**
- GitHub: [@Sahilp2407](https://github.com/Sahilp2407)
- Project: **College Assignment 6 - Dynamic Product Catalog**
