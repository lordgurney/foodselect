import 'package:flutter/material.dart';

enum DietaryPreference {
  glutenFree,
  nutFree,
  dairyFree,
  vegetarian,
  vegan,
  halal,
  eggFree,
}

extension DietaryPreferenceExtension on DietaryPreference {
  String get displayName {
    switch (this) {
      case DietaryPreference.glutenFree:
        return 'Gluten-Free';
      case DietaryPreference.nutFree:
        return 'Nut-Free';
      case DietaryPreference.dairyFree:
        return 'Dairy-Free';
      case DietaryPreference.vegetarian:
        return 'Vegetarian';
      case DietaryPreference.vegan:
        return 'Vegan';
      case DietaryPreference.halal:
        return 'Halal';
      case DietaryPreference.eggFree:
        return 'Egg-Free';
    }
  }

  String get shortCode {
    switch (this) {
      case DietaryPreference.glutenFree:
        return 'GF';
      case DietaryPreference.nutFree:
        return 'NF';
      case DietaryPreference.dairyFree:
        return 'DF';
      case DietaryPreference.vegetarian:
        return 'V';
      case DietaryPreference.vegan:
        return 'VG';
      case DietaryPreference.halal:
        return 'H';
      case DietaryPreference.eggFree:
        return 'EF';
    }
  }

  IconData get icon {
    switch (this) {
      case DietaryPreference.glutenFree:
        return Icons.grain;
      case DietaryPreference.nutFree:
        return Icons.shield_outlined;
      case DietaryPreference.dairyFree:
        return Icons.water_drop_outlined;
      case DietaryPreference.vegetarian:
        return Icons.eco;
      case DietaryPreference.vegan:
        return Icons.spa;
      case DietaryPreference.halal:
        return Icons.verified;
      case DietaryPreference.eggFree:
        return Icons.egg_outlined;
    }
  }

  Color get color {
    switch (this) {
      case DietaryPreference.glutenFree:
        return const Color(0xFFD97706); // Warm amber
      case DietaryPreference.nutFree:
        return const Color(0xFFDC2626); // Crimson safety
      case DietaryPreference.dairyFree:
        return const Color(0xFF0284C7); // Sky blue
      case DietaryPreference.vegetarian:
        return const Color(0xFF16A34A); // Green
      case DietaryPreference.vegan:
        return const Color(0xFF059669); // Emerald
      case DietaryPreference.halal:
        return const Color(0xFF7C3AED); // Purple
      case DietaryPreference.eggFree:
        return const Color(0xFFEA580C); // Orange
    }
  }
}
