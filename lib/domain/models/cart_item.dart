import 'food_item.dart';

class CartItem {
  final String uniqueCartId;
  final FoodItem foodItem;
  int quantity;
  final List<CustomizationOption> selectedCustomizations;
  final String specialDietaryNotes;

  CartItem({
    required this.uniqueCartId,
    required this.foodItem,
    this.quantity = 1,
    this.selectedCustomizations = const [],
    this.specialDietaryNotes = '',
  });

  double get unitPrice {
    double base = foodItem.price;
    for (final opt in selectedCustomizations) {
      base += opt.extraPrice;
    }
    return base;
  }

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    String? uniqueCartId,
    FoodItem? foodItem,
    int? quantity,
    List<CustomizationOption>? selectedCustomizations,
    String? specialDietaryNotes,
  }) {
    return CartItem(
      uniqueCartId: uniqueCartId ?? this.uniqueCartId,
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
      selectedCustomizations: selectedCustomizations ?? this.selectedCustomizations,
      specialDietaryNotes: specialDietaryNotes ?? this.specialDietaryNotes,
    );
  }
}
