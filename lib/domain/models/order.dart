import 'cart_item.dart';
import 'dietary_type.dart';
import 'meal_period.dart';
import 'student.dart';

class CafeteriaOrder {
  final String orderId;
  final Student student;
  final List<CartItem> items;
  final MealPeriod mealPeriod;
  final double totalAmount;
  final DateTime orderTime;
  final String cardLastFour;
  final String pickupCounter;
  final bool hasSpecialDietaryPrep;
  final List<String> flaggedDietaryNotes;

  const CafeteriaOrder({
    required this.orderId,
    required this.student,
    required this.items,
    required this.mealPeriod,
    required this.totalAmount,
    required this.orderTime,
    required this.cardLastFour,
    required this.pickupCounter,
    required this.hasSpecialDietaryPrep,
    required this.flaggedDietaryNotes,
  });

  static CafeteriaOrder create({
    required Student student,
    required List<CartItem> items,
    required MealPeriod mealPeriod,
    required String cardLastFour,
  }) {
    final now = DateTime.now();
    final randomSuffix = (now.millisecondsSinceEpoch % 9000 + 1000).toString();
    final orderId = 'HS-$randomSuffix';

    double total = 0;
    bool specialPrep = false;
    List<String> notes = [];

    for (final item in items) {
      total += item.totalPrice;
      if (item.specialDietaryNotes.trim().isNotEmpty) {
        specialPrep = true;
        notes.add('${item.foodItem.name}: ${item.specialDietaryNotes}');
      }
      // If student or item has high dietary sensitivity like GF or Nut-free
      if (item.foodItem.dietaryBadges.contains(DietaryPreference.glutenFree) ||
          item.foodItem.dietaryBadges.contains(DietaryPreference.nutFree) ||
          item.foodItem.dietaryBadges.contains(DietaryPreference.halal)) {
        specialPrep = true;
      }
    }

    if (student.medicalAllergies.isNotEmpty) {
      specialPrep = true;
      notes.add('Student record alert: ${student.medicalAllergies.join(", ")}');
    }

    final pickupCounter = specialPrep
        ? 'Counter 3 • Special Dietary & Allergen-Safe Station'
        : 'Counter 1 • Express Cafeteria Pickup';

    return CafeteriaOrder(
      orderId: orderId,
      student: student,
      items: List.unmodifiable(items),
      mealPeriod: mealPeriod,
      totalAmount: total,
      orderTime: now,
      cardLastFour: cardLastFour,
      pickupCounter: pickupCounter,
      hasSpecialDietaryPrep: specialPrep,
      flaggedDietaryNotes: notes,
    );
  }
}
