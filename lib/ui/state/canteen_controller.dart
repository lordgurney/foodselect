import 'package:flutter/foundation.dart';
import '../../data/mock_menu_data.dart';
import '../../data/mock_student_service.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/models/dietary_type.dart';
import '../../domain/models/food_item.dart';
import '../../domain/models/meal_period.dart';
import '../../domain/models/order.dart';
import '../../domain/models/student.dart';

class CanteenController extends ChangeNotifier {
  MealPeriod _selectedMealPeriod = MealPeriod.lunch;
  final Set<DietaryPreference> _selectedDietaryFilters = {};
  FoodCategory? _selectedCategory;
  String _searchQuery = '';

  final List<CartItem> _cartItems = [];
  Student? _verifiedStudent;
  bool _isVerifyingStudent = false;
  String? _verificationError;

  CafeteriaOrder? _activeOrder;

  // Getters
  MealPeriod get selectedMealPeriod => _selectedMealPeriod;
  Set<DietaryPreference> get selectedDietaryFilters => Set.unmodifiable(_selectedDietaryFilters);
  FoodCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  Student? get verifiedStudent => _verifiedStudent;
  bool get isVerifyingStudent => _isVerifyingStudent;
  String? get verificationError => _verificationError;
  CafeteriaOrder? get activeOrder => _activeOrder;

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get cartSubtotal => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Filters items based on search query, category, and selected dietary preferences
  List<FoodItem> get filteredItems {
    return MockMenuData.items.where((item) {
      // 1. Availability for period
      if (_selectedMealPeriod == MealPeriod.recess && !item.isAvailableForRecess) {
        return false;
      }
      if (_selectedMealPeriod == MealPeriod.lunch && !item.isAvailableForLunch) {
        return false;
      }

      // 2. Category filter
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
      }

      // 3. Dietary preferences filter (all selected filters must match)
      if (_selectedDietaryFilters.isNotEmpty && !item.meetsAllPreferences(_selectedDietaryFilters)) {
        return false;
      }

      // 4. Search query
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase().trim();
        final matchName = item.name.toLowerCase().contains(query);
        final matchDesc = item.description.toLowerCase().contains(query);
        final matchAllergens = item.allergens.any((a) => a.toLowerCase().contains(query));
        final matchBadges = item.dietaryBadges.any((b) => b.displayName.toLowerCase().contains(query));
        if (!matchName && !matchDesc && !matchAllergens && !matchBadges) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void setMealPeriod(MealPeriod period) {
    if (_selectedMealPeriod != period) {
      _selectedMealPeriod = period;
      notifyListeners();
    }
  }

  void toggleDietaryFilter(DietaryPreference preference) {
    if (_selectedDietaryFilters.contains(preference)) {
      _selectedDietaryFilters.remove(preference);
    } else {
      _selectedDietaryFilters.add(preference);
    }
    notifyListeners();
  }

  void clearDietaryFilters() {
    if (_selectedDietaryFilters.isNotEmpty) {
      _selectedDietaryFilters.clear();
      notifyListeners();
    }
  }

  void setSelectedCategory(FoodCategory? category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addToCart({
    required FoodItem foodItem,
    required int quantity,
    required List<CustomizationOption> customizations,
    required String specialNotes,
  }) {
    // Generate unique ID based on item and customizations
    final custIds = customizations.map((c) => c.id).join('-');
    final uniqueId = '${foodItem.id}_${custIds}_${specialNotes.trim().hashCode}';

    final existingIndex = _cartItems.indexWhere((c) => c.uniqueCartId == uniqueId);
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(
        CartItem(
          uniqueCartId: uniqueId,
          foodItem: foodItem,
          quantity: quantity,
          selectedCustomizations: customizations,
          specialDietaryNotes: specialNotes.trim(),
        ),
      );
    }
    notifyListeners();
  }

  void updateCartItemQuantity(String cartItemId, int delta) {
    final index = _cartItems.indexWhere((c) => c.uniqueCartId == cartItemId);
    if (index >= 0) {
      final newQuantity = _cartItems[index].quantity + delta;
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeFromCart(String cartItemId) {
    _cartItems.removeWhere((c) => c.uniqueCartId == cartItemId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  Future<bool> verifyStudentId(String id) async {
    _isVerifyingStudent = true;
    _verificationError = null;
    notifyListeners();

    try {
      final student = await StudentService.verifyStudentId(id);
      _verifiedStudent = student;
      _isVerifyingStudent = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isVerifyingStudent = false;
      _verificationError = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void setStudentDirectly(Student student) {
    _verifiedStudent = student;
    _verificationError = null;
    notifyListeners();
  }

  void clearVerifiedStudent() {
    _verifiedStudent = null;
    _verificationError = null;
    notifyListeners();
  }

  /// Checks if any item in cart potentially conflicts with student's medical allergy profile
  List<String> getDietaryAllergyWarnings() {
    if (_verifiedStudent == null || _verifiedStudent!.medicalAllergies.isEmpty) {
      return [];
    }

    final warnings = <String>[];
    for (final item in _cartItems) {
      for (final medicalAllergy in _verifiedStudent!.medicalAllergies) {
        final allergyLower = medicalAllergy.toLowerCase();
        // Check if any allergen contains this keyword or if the item lacks the safety badge
        if (allergyLower.contains('nut') || allergyLower.contains('peanut')) {
          if (!item.foodItem.dietaryBadges.contains(DietaryPreference.nutFree)) {
            warnings.add('${item.foodItem.name} is not certified Nut-Free (Registered allergy: $medicalAllergy)');
          }
        } else if (allergyLower.contains('gluten') || allergyLower.contains('celiac')) {
          if (!item.foodItem.dietaryBadges.contains(DietaryPreference.glutenFree)) {
            warnings.add('${item.foodItem.name} contains gluten (Registered allergy: $medicalAllergy)');
          }
        } else if (allergyLower.contains('milk') || allergyLower.contains('dairy')) {
          if (!item.foodItem.dietaryBadges.contains(DietaryPreference.dairyFree)) {
            warnings.add('${item.foodItem.name} contains dairy/milk (Registered allergy: $medicalAllergy)');
          }
        }
      }
    }
    return warnings.toSet().toList();
  }

  /// Finalize order and return confirmation
  CafeteriaOrder placeOrder({required String cardLastFour}) {
    if (_verifiedStudent == null) {
      throw Exception('Student must be verified before placing order.');
    }
    if (_cartItems.isEmpty) {
      throw Exception('Cart cannot be empty.');
    }

    final order = CafeteriaOrder.create(
      student: _verifiedStudent!,
      items: List.from(_cartItems),
      mealPeriod: _selectedMealPeriod,
      cardLastFour: cardLastFour,
    );

    _activeOrder = order;
    _cartItems.clear();
    notifyListeners();
    return order;
  }

  void startNewOrder() {
    _activeOrder = null;
    _cartItems.clear();
    notifyListeners();
  }
}
