import '../domain/models/dietary_type.dart';
import '../domain/models/food_item.dart';

class MockMenuData {
  static final List<FoodItem> items = [
    // ---------------- HOT MEALS ----------------
    FoodItem(
      id: 'hot-01',
      name: 'Tuscan Grilled Chicken & Rice Bowl',
      description: 'Marinated herb chicken breast, brown rice, roasted zucchini, and fresh lemon herb dressing.',
      price: 7.50,
      category: FoodCategory.hotMeals,
      dietaryBadges: {
        DietaryPreference.glutenFree,
        DietaryPreference.halal,
        DietaryPreference.nutFree,
        DietaryPreference.dairyFree,
        DietaryPreference.eggFree,
      },
      allergens: const ['None of top 9 priority allergens'],
      calories: 460,
      emoji: '🍗',
      customizationGroups: [
        CustomizationGroup(
          groupName: 'Base Grain',
          isRequired: true,
          options: [
            CustomizationOption(id: 'rice-brown', title: 'Steamed Brown Rice (GF)'),
            CustomizationOption(id: 'rice-quinoa', title: 'Quinoa Blend (GF)', extraPrice: 0.50),
          ],
        ),
        CustomizationGroup(
          groupName: 'Dietary Modifications',
          allowsMultiple: true,
          options: [
            CustomizationOption(
              id: 'sauce-on-side',
              title: 'Dressing on the side',
            ),
            CustomizationOption(
              id: 'extra-greens',
              title: 'Add Steamed Broccoli',
              extraPrice: 1.00,
            ),
          ],
        ),
      ],
    ),
    FoodItem(
      id: 'hot-02',
      name: 'Warm Falafel & Hummus Pocket',
      description: 'Herbed chickpea falafels, creamy garlic-free hummus, shredded crisp lettuce, tomato, and cucumber in wholemeal pita.',
      price: 6.80,
      category: FoodCategory.hotMeals,
      dietaryBadges: {
        DietaryPreference.vegetarian,
        DietaryPreference.vegan,
        DietaryPreference.halal,
        DietaryPreference.nutFree,
        DietaryPreference.dairyFree,
        DietaryPreference.eggFree,
      },
      allergens: const ['Wheat (Gluten), Sesame'],
      calories: 420,
      emoji: '🧆',
      customizationGroups: [
        CustomizationGroup(
          groupName: 'Bread Selection',
          isRequired: true,
          options: [
            CustomizationOption(id: 'pita-wholemeal', title: 'Wholemeal Pita Pocket'),
            CustomizationOption(
              id: 'pita-gf',
              title: 'Gluten-Free Warm Wrap',
              extraPrice: 1.00,
              dietaryImpact: DietaryPreference.glutenFree,
            ),
          ],
        ),
        CustomizationGroup(
          groupName: 'Toppings & Pickles',
          allowsMultiple: true,
          options: [
            CustomizationOption(id: 'extra-tahini', title: 'Extra Tahini Drizzle'),
            CustomizationOption(id: 'pickled-turnips', title: 'Pink Pickled Turnips'),
          ],
        ),
      ],
    ),
    FoodItem(
      id: 'hot-03',
      name: 'Gluten-Free 3-Cheese Macaroni',
      description: 'Corn & rice pasta baked with mild cheddar, mozzarella, and a crunchy gluten-free herb crumb.',
      price: 6.50,
      category: FoodCategory.hotMeals,
      dietaryBadges: {
        DietaryPreference.glutenFree,
        DietaryPreference.vegetarian,
        DietaryPreference.nutFree,
        DietaryPreference.eggFree,
      },
      allergens: const ['Milk (Dairy)'],
      calories: 480,
      emoji: '🧀',
      customizationGroups: [
        CustomizationGroup(
          groupName: 'Add-ons',
          allowsMultiple: true,
          options: [
            CustomizationOption(id: 'mac-peas', title: 'Mix in Sweet Green Peas', extraPrice: 0.50),
            CustomizationOption(id: 'mac-extra-cheese', title: 'Extra Crispy Cheese Crust', extraPrice: 0.75),
          ],
        ),
      ],
    ),
    FoodItem(
      id: 'hot-04',
      name: 'Japanese Teriyaki Tofu Bowl',
      description: 'Crispy organic tofu glazed with sweet tamari teriyaki, edamame beans, grated carrots, and sushi rice.',
      price: 7.20,
      category: FoodCategory.hotMeals,
      dietaryBadges: {
        DietaryPreference.vegetarian,
        DietaryPreference.vegan,
        DietaryPreference.halal,
        DietaryPreference.glutenFree,
        DietaryPreference.nutFree,
        DietaryPreference.dairyFree,
        DietaryPreference.eggFree,
      },
      allergens: const ['Soy'],
      calories: 390,
      emoji: '🍱',
      customizationGroups: [
        CustomizationGroup(
          groupName: 'Spice Level',
          isRequired: true,
          options: [
            CustomizationOption(id: 'sp-mild', title: 'Mild Sweet Glaze'),
            CustomizationOption(id: 'sp-chili', title: 'Add Shichimi Chili Flakes'),
          ],
        ),
      ],
    ),
    FoodItem(
      id: 'hot-05',
      name: 'Slow-Cooked Beef & Veggie Bolognese',
      description: '100% Halal lean ground beef simmered with grated carrots, zucchini, and San Marzano tomatoes over spiral pasta.',
      price: 7.20,
      category: FoodCategory.hotMeals,
      dietaryBadges: {
        DietaryPreference.halal,
        DietaryPreference.nutFree,
        DietaryPreference.eggFree,
      },
      allergens: const ['Wheat (Gluten)', 'Milk (Parmesan optional)'],
      calories: 510,
      emoji: '🍝',
      customizationGroups: [
        CustomizationGroup(
          groupName: 'Pasta Selection',
          isRequired: true,
          options: [
            CustomizationOption(id: 'pasta-regular', title: 'Whole Wheat Spirals'),
            CustomizationOption(
              id: 'pasta-gf',
              title: 'Gluten-Free Rice Spirals',
              extraPrice: 0.80,
              dietaryImpact: DietaryPreference.glutenFree,
            ),
          ],
        ),
        CustomizationGroup(
          groupName: 'Cheese Garnish',
          isRequired: true,
          options: [
            CustomizationOption(id: 'ch-parm', title: 'Sprinkled Parmesan Cheese'),
            CustomizationOption(
              id: 'ch-none',
              title: 'No Cheese (Dairy-Free Prep)',
              dietaryImpact: DietaryPreference.dairyFree,
            ),
          ],
        ),
      ],
    ),

    // ---------------- SANDWICHES & WRAPS ----------------
    FoodItem(
      id: 'sand-01',
      name: 'Roast Turkey & Avocado Deli Wrap',
      description: 'Shaved free-range turkey breast, crushed avocado, baby spinach, and cranberry relish in a soft tortilla.',
      price: 6.20,
      category: FoodCategory.sandwichesAndWraps,
      dietaryBadges: {
        DietaryPreference.halal,
        DietaryPreference.nutFree,
        DietaryPreference.dairyFree,
        DietaryPreference.eggFree,
      },
      allergens: const ['Wheat (Gluten)'],
      calories: 380,
      emoji: '🌯',
      customizationGroups: [
        CustomizationGroup(
          groupName: 'Wrap Type',
          isRequired: true,
          options: [
            CustomizationOption(id: 'wrap-flour', title: 'Flour Tortilla'),
            CustomizationOption(id: 'wrap-spinach', title: 'Spinach Herb Wrap'),
            CustomizationOption(
              id: 'wrap-gf',
              title: 'Gluten-Free Wrap',
              extraPrice: 1.00,
              dietaryImpact: DietaryPreference.glutenFree,
            ),
          ],
        ),
      ],
    ),
    FoodItem(
      id: 'sand-02',
      name: 'Rainbow Veggie & Beet Hummus Sandwich',
      description: 'Vibrant beetroot hummus, grated carrot, sliced English cucumber, alfalfa sprouts, and ripe tomatoes.',
      price: 5.80,
      category: FoodCategory.sandwichesAndWraps,
      dietaryBadges: {
        DietaryPreference.vegetarian,
        DietaryPreference.vegan,
        DietaryPreference.halal,
        DietaryPreference.nutFree,
        DietaryPreference.dairyFree,
        DietaryPreference.eggFree,
      },
      allergens: const ['Wheat (Gluten)', 'Sesame'],
      calories: 330,
      emoji: '🥪',
      customizationGroups: [
        CustomizationGroup(
          groupName: 'Bread Selection',
          isRequired: true,
          options: [
            CustomizationOption(id: 'bread-grain', title: 'Multigrain Bread'),
            CustomizationOption(id: 'bread-sourdough', title: 'Artisan Sourdough'),
            CustomizationOption(
              id: 'bread-gf',
              title: 'Gluten-Free Seeded Slices',
              extraPrice: 1.00,
              dietaryImpact: DietaryPreference.glutenFree,
            ),
          ],
        ),
      ],
    ),
    FoodItem(
      id: 'sand-03',
      name: 'Farm Fresh Egg Mayo & Chive Baguette',
      description: 'Pasture-raised eggs gently folded with creamy light mayonnaise, fresh garden chives, and crisp iceberg lettuce.',
      price: 5.50,
      category: FoodCategory.sandwichesAndWraps,
      dietaryBadges: {
        DietaryPreference.vegetarian,
        DietaryPreference.halal,
        DietaryPreference.nutFree,
        DietaryPreference.dairyFree,
      },
      allergens: const ['Egg', 'Wheat (Gluten)'],
      calories: 390,
      emoji: '🥖',
      customizationGroups: [
        CustomizationGroup(
          groupName: 'Seasoning',
          options: [
            CustomizationOption(id: 'seasoning-cracked-pepper', title: 'Fresh Cracked Pepper'),
            CustomizationOption(id: 'seasoning-mild-mustard', title: 'Touch of Dijon Mustard'),
          ],
        ),
      ],
    ),

    // ---------------- FRESH SALADS & BOWLS ----------------
    FoodItem(
      id: 'sal-01',
      name: 'Mediterranean Quinoa & Chickpea Bowl',
      description: 'Fluffy tri-color quinoa, Kalamata olives, diced cucumbers, sweet cherry tomatoes, and tangy oregano vinaigrette.',
      price: 6.50,
      category: FoodCategory.saladsAndBowls,
      dietaryBadges: {
        DietaryPreference.glutenFree,
        DietaryPreference.vegan,
        DietaryPreference.vegetarian,
        DietaryPreference.halal,
        DietaryPreference.nutFree,
        DietaryPreference.dairyFree,
        DietaryPreference.eggFree,
      },
      allergens: const ['None'],
      calories: 340,
      emoji: '🥗',
      customizationGroups: [
        CustomizationGroup(
          groupName: 'Optional Cheese',
          isRequired: true,
          options: [
            CustomizationOption(id: 'feta-none', title: 'No Cheese (100% Vegan/Dairy-Free)'),
            CustomizationOption(id: 'feta-add', title: 'Crumbled Greek Feta Cheese', extraPrice: 0.75),
          ],
        ),
      ],
    ),
    FoodItem(
      id: 'sal-02',
      name: 'Crispy Halal Chicken Tender Salad',
      description: 'Golden oven-baked Halal chicken breast strips, crisp romaine, shredded red cabbage, sweet corn, and honey mustard.',
      price: 7.00,
      category: FoodCategory.saladsAndBowls,
      dietaryBadges: {
        DietaryPreference.halal,
        DietaryPreference.nutFree,
        DietaryPreference.dairyFree,
        DietaryPreference.eggFree,
      },
      allergens: const ['Wheat (Gluten)'],
      calories: 440,
      emoji: '🥗',
      customizationGroups: [
        CustomizationGroup(
          groupName: 'Dressing Choice',
          isRequired: true,
          options: [
            CustomizationOption(id: 'dr-honeymustard', title: 'Honey Mustard Vinaigrette'),
            CustomizationOption(id: 'dr-lemonolive', title: 'Lemon Olive Oil Dressing'),
          ],
        ),
      ],
    ),

    // ---------------- SNACKS & BAKERY ----------------
    FoodItem(
      id: 'snk-01',
      name: 'Certified Gluten-Free Blueberry Muffin',
      description: 'Moist golden muffin loaded with wild organic blueberries, baked in a certified gluten-free & nut-free facility.',
      price: 3.50,
      category: FoodCategory.snacksAndBakery,
      dietaryBadges: {
        DietaryPreference.glutenFree,
        DietaryPreference.vegetarian,
        DietaryPreference.nutFree,
        DietaryPreference.halal,
      },
      allergens: const ['Egg', 'Milk'],
      calories: 260,
      emoji: '🧁',
      customizationGroups: [
        CustomizationGroup(
          groupName: 'Serving Temperature',
          isRequired: true,
          options: [
            CustomizationOption(id: 'muffin-warm', title: 'Warm & Toasted'),
            CustomizationOption(id: 'muffin-room', title: 'Room Temperature'),
          ],
        ),
      ],
    ),
    FoodItem(
      id: 'snk-02',
      name: 'Crisp Apple Slices with SunButter® Dip',
      description: 'Crisp Pink Lady apple wedges served with roasted sunflower seed butter. 100% nut-free and high in protein.',
      price: 3.20,
      category: FoodCategory.snacksAndBakery,
      dietaryBadges: {
        DietaryPreference.glutenFree,
        DietaryPreference.nutFree,
        DietaryPreference.dairyFree,
        DietaryPreference.vegetarian,
        DietaryPreference.vegan,
        DietaryPreference.halal,
        DietaryPreference.eggFree,
      },
      allergens: const ['None (Sunflower seed butter is strictly peanut & tree nut free)'],
      calories: 190,
      emoji: '🍏',
    ),
    FoodItem(
      id: 'snk-03',
      name: 'Baked Whole-Grain Pita Chips & Tzatziki',
      description: 'Oven-toasted sea salt pita chips served with cool cucumber and garlic yogurt dip.',
      price: 3.00,
      category: FoodCategory.snacksAndBakery,
      dietaryBadges: {
        DietaryPreference.vegetarian,
        DietaryPreference.halal,
        DietaryPreference.nutFree,
        DietaryPreference.eggFree,
      },
      allergens: const ['Wheat (Gluten)', 'Milk (Dairy)'],
      calories: 220,
      emoji: '🥨',
    ),
    FoodItem(
      id: 'snk-04',
      name: 'Ripe Banana & Oat Energy Bread',
      description: 'Hearty homemade slice made with rolled oats, ripe Cavendish bananas, and cinnamon. Dairy-free recipe.',
      price: 2.80,
      category: FoodCategory.snacksAndBakery,
      dietaryBadges: {
        DietaryPreference.vegetarian,
        DietaryPreference.dairyFree,
        DietaryPreference.nutFree,
        DietaryPreference.halal,
      },
      allergens: const ['Oats (Gluten)', 'Egg'],
      calories: 240,
      emoji: '🍞',
    ),

    // ---------------- BEVERAGES ----------------
    FoodItem(
      id: 'drk-01',
      name: 'Cold-Pressed Valencia Orange Juice',
      description: '100% pure squeezed Australian Valencia oranges. No added sugars, preservatives, or artificial colors.',
      price: 3.00,
      category: FoodCategory.drinks,
      dietaryBadges: {
        DietaryPreference.glutenFree,
        DietaryPreference.nutFree,
        DietaryPreference.dairyFree,
        DietaryPreference.vegetarian,
        DietaryPreference.vegan,
        DietaryPreference.halal,
        DietaryPreference.eggFree,
      },
      allergens: const ['None'],
      calories: 110,
      emoji: '🍊',
    ),
    FoodItem(
      id: 'drk-02',
      name: 'Oat Milk Iced Chocolate',
      description: 'Rich Fairtrade cocoa blended with creamy gluten-free oat milk. 100% plant-based and dairy-free.',
      price: 3.80,
      category: FoodCategory.drinks,
      dietaryBadges: {
        DietaryPreference.dairyFree,
        DietaryPreference.vegetarian,
        DietaryPreference.vegan,
        DietaryPreference.nutFree,
        DietaryPreference.halal,
        DietaryPreference.eggFree,
      },
      allergens: const ['Oats'],
      calories: 180,
      emoji: '🍫',
    ),
    FoodItem(
      id: 'drk-03',
      name: 'Sparkling Lemon & Lime Spring Water',
      description: 'Lightly carbonated mineral water infused with natural lemon & lime essence. Zero sugar.',
      price: 2.50,
      category: FoodCategory.drinks,
      dietaryBadges: {
        DietaryPreference.glutenFree,
        DietaryPreference.nutFree,
        DietaryPreference.dairyFree,
        DietaryPreference.vegetarian,
        DietaryPreference.vegan,
        DietaryPreference.halal,
        DietaryPreference.eggFree,
      },
      allergens: const ['None'],
      calories: 0,
      emoji: '🍋',
    ),
    FoodItem(
      id: 'drk-04',
      name: 'Low-Fat Organic Dairy Milk (250ml)',
      description: 'High calcium fresh dairy milk from local certified organic pasture farms.',
      price: 2.20,
      category: FoodCategory.drinks,
      dietaryBadges: {
        DietaryPreference.glutenFree,
        DietaryPreference.nutFree,
        DietaryPreference.vegetarian,
        DietaryPreference.halal,
        DietaryPreference.eggFree,
      },
      allergens: const ['Milk (Dairy)'],
      calories: 130,
      emoji: '🥛',
    ),
  ];
}
