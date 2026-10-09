import 'package:flutter_test/flutter_test.dart';
import 'package:food_select/domain/models/dietary_type.dart';
import 'package:food_select/main.dart';
import 'package:food_select/ui/state/canteen_controller.dart';

void main() {
  testWidgets('App renders Canteen Home and dietary filters correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodSelectApp());
    await tester.pumpAndSettle();

    // Verify School Canteen branding
    expect(find.text('Oakwood High Canteen'), findsOneWidget);

    // Verify Meal Period selector
    expect(find.text('Recess (10:45 AM)'), findsOneWidget);
    expect(find.text('Lunch (1:15 PM)'), findsOneWidget);

    // Verify Dietary options are present
    expect(find.text('All Foods'), findsOneWidget);
    expect(find.text('Gluten-Free'), findsOneWidget);
    expect(find.text('Nut-Free'), findsOneWidget);
  });

  test('CanteenController dietary filtering logic works properly', () {
    final controller = CanteenController();

    // Initially all items for lunch
    final initialCount = controller.filteredItems.length;
    expect(initialCount, greaterThan(0));

    // Filter by Gluten-Free
    controller.toggleDietaryFilter(DietaryPreference.glutenFree);
    for (final item in controller.filteredItems) {
      expect(item.dietaryBadges.contains(DietaryPreference.glutenFree), isTrue);
    }

    // Toggle off
    controller.toggleDietaryFilter(DietaryPreference.glutenFree);
    expect(controller.filteredItems.length, equals(initialCount));
  });

  test('Student verification and allergy warning cross-check', () async {
    final controller = CanteenController();

    // S1042 has peanut/tree nut allergy
    final verified = await controller.verifyStudentId('S1042');
    expect(verified, isTrue);
    expect(controller.verifiedStudent?.fullName, equals('Alex Morgan'));

    // Check allergy warnings when empty
    expect(controller.getDietaryAllergyWarnings(), isEmpty);
  });
}
