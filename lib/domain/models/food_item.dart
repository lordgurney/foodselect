import 'dietary_type.dart';

enum FoodCategory {
  hotMeals,
  sandwichesAndWraps,
  saladsAndBowls,
  snacksAndBakery,
  drinks,
}

extension FoodCategoryExtension on FoodCategory {
  String get displayName {
    switch (this) {
      case FoodCategory.hotMeals:
        return 'Hot Meals';
      case FoodCategory.sandwichesAndWraps:
        return 'Sandwiches & Wraps';
      case FoodCategory.saladsAndBowls:
        return 'Fresh Salads & Bowls';
      case FoodCategory.snacksAndBakery:
        return 'Snacks & Bakery';
      case FoodCategory.drinks:
        return 'Beverages';
    }
  }
}

class CustomizationOption {
  final String id;
  final String title;
  final double extraPrice;
  final DietaryPreference? dietaryImpact;

  const CustomizationOption({
    required this.id,
    required this.title,
    this.extraPrice = 0.0,
    this.dietaryImpact,
  });
}

class CustomizationGroup {
  final String groupName;
  final bool isRequired;
  final bool allowsMultiple;
  final List<CustomizationOption> options;

  const CustomizationGroup({
    required this.groupName,
    this.isRequired = false,
    this.allowsMultiple = false,
    required this.options,
  });
}

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final FoodCategory category;
  final Set<DietaryPreference> dietaryBadges;
  final List<String> allergens;
  final int calories;
  final String emoji;
  final List<CustomizationGroup> customizationGroups;
  final bool isAvailableForRecess;
  final bool isAvailableForLunch;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.dietaryBadges,
    required this.allergens,
    required this.calories,
    required this.emoji,
    this.customizationGroups = const [],
    this.isAvailableForRecess = true,
    this.isAvailableForLunch = true,
  });

  bool meetsDietaryPreference(DietaryPreference preference) {
    return dietaryBadges.contains(preference);
  }

  bool meetsAllPreferences(Set<DietaryPreference> preferences) {
    if (preferences.isEmpty) return true;
    return preferences.every((pref) => dietaryBadges.contains(pref));
  }
}
