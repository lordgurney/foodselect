# Oakwood High School Canteen - Food Ordering System

A cross-platform Flutter application tailored for high schools (1,000+ students) to streamline cafeteria pre-ordering, reduce morning & lunch break queue times, and provide robust dietary and allergen management.

---

## 🌟 Key Features

### 1. Simple, Clean Flow (Home to Checkout)
- **Home & Menu Exploration**:
  - Live meal period selector: **Morning Recess** (10:45 AM) vs. **Lunch Break** (1:15 PM) with cut-off alerts.
  - Search by item name, description, ingredients, or allergens.
  - Category selector: Hot Meals, Sandwiches & Wraps, Fresh Salads & Bowls, Snacks & Bakery, Beverages.
- **Dietary Filter System**:
  - Instant multi-select filters:
    - 🌾 **Gluten-Free (GF)**
    - 🛡️ **Nut-Free (NF)**
    - 💧 **Dairy-Free (DF)**
    - 🌿 **Vegetarian (V)**
    - 🌱 **Vegan (VG)**
    - ☪️ **Halal (H)**
    - 🥚 **Egg-Free (EF)**
  - Prominent allergen statements on every card and detailed customization modal.
- **Dietary Customization & Kitchen Notes**:
  - Bread substitutes (e.g. Gluten-Free Wrap, GF bread).
  - Dairy-free substitutions (e.g. no cheese, oat milk swap).
  - Free-form dietary / allergy instruction field that tags orders for preparation in dedicated allergen-safe zones.
- **Cart / Tray Sheet**:
  - Fast item overview, quantity adjustments, itemized price breakdown, and dietary tags summary.
- **Two-Step Checkout**:
  - **Step 1: Student ID Verification**:
    - Enter student ID (e.g. `S1042`, `S3114`, `S2095`, `S4050`) or use quick test profiles.
    - Verified against school directory for grade, homeroom, and recorded medical allergies.
    - **Allergy Safety Cross-Check**: If a student has a recorded allergy (e.g. Celiac / Peanuts) and an item in the tray conflicts, an alert notice is shown.
  - **Step 2: Pay with Card**:
    - Student/Parent Card payment with test card auto-fill, card number, expiry, and CVV.
- **Digital Pickup Ticket**:
  - Assigned **Special Dietary Service Counter (Counter 3)** for orders with allergen/dietary flags, or **Express Pickup (Counter 1)** for standard orders.
  - Digital barcode / QR code simulation for fast scanning at the canteen counter.

---

## 🚀 How to Run

### Run on Chrome (Web)
```bash
flutter run -d chrome
```

### Run on Windows Desktop
```bash
flutter run -d windows
```

### Run Tests
```bash
flutter test
```

---

## 🏫 Sample Test Student IDs
| Student ID | Student Name | Grade & Homeroom | Registered Dietary / Medical Allergy Profile |
|------------|--------------|------------------|----------------------------------------------|
| `S1042`    | Alex Morgan  | Grade 10 • 10-B  | Severe Peanuts & Tree Nuts Allergy           |
| `S3114`    | Liam Chen    | Grade 9 • 9-A    | Celiac Disease (Gluten-Free) & Cow Milk      |
| `S2095`    | Fatima Al-M. | Grade 11 • 11-C  | Halal Only Preference                        |
| `S4050`    | Zoe Wash.    | Grade 12 • 12-E  | Vegan & Vegetarian Profile                   |
| `S5001`    | Jordan T.    | Grade 10 • 10-D  | Standard / No dietary restrictions           |
