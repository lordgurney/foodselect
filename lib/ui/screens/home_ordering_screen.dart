import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/dietary_type.dart';
import '../../domain/models/food_item.dart';
import '../../domain/models/meal_period.dart';
import '../state/canteen_controller.dart';
import 'cart_sheet.dart';
import 'item_detail_sheet.dart';

class HomeOrderingScreen extends StatefulWidget {
  final CanteenController controller;

  const HomeOrderingScreen({super.key, required this.controller});

  @override
  State<HomeOrderingScreen> createState() => _HomeOrderingScreenState();
}

class _HomeOrderingScreenState extends State<HomeOrderingScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;
        final filteredItems = controller.filteredItems;
        final cartCount = controller.cartCount;

        return Scaffold(
          appBar: _buildAppBar(context, controller, cartCount),
          body: Column(
            children: [
              // Meal Period Picker (Recess vs Lunch)
              _buildMealPeriodSelector(controller),

              // Search Bar
              _buildSearchBar(controller),

              // Dietary Filter Bar
              _buildDietaryFilterBar(controller),

              // Category Selector Tabs
              _buildCategorySelector(controller),

              // Menu Items List / Grid
              Expanded(
                child: filteredItems.isEmpty
                    ? _buildEmptyState(controller)
                    : _buildMenuGrid(context, controller, filteredItems),
              ),

              // Bottom Cart Bar
              if (cartCount > 0) _buildBottomCartBar(context, controller),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, CanteenController controller, int cartCount) {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.school, size: 22, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Oakwood High Canteen',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                '1,000+ Students • Fresh Daily Pre-Orders',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
              tooltip: 'View Tray',
              onPressed: () => CartSheet.show(context, controller),
            ),
            if (cartCount > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.rose,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    '$cartCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildMealPeriodSelector(CanteenController controller) {
    final active = controller.selectedMealPeriod;

    return Container(
      color: AppColors.primaryDark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.access_time_filled, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          const Text(
            'Order for:',
            style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                _mealPeriodButton(
                  title: 'Recess (10:45 AM)',
                  isSelected: active == MealPeriod.recess,
                  onTap: () => controller.setMealPeriod(MealPeriod.recess),
                ),
                const SizedBox(width: 8),
                _mealPeriodButton(
                  title: 'Lunch (1:15 PM)',
                  isSelected: active == MealPeriod.lunch,
                  onTap: () => controller.setMealPeriod(MealPeriod.lunch),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mealPeriodButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primary : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(CanteenController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      color: AppColors.background,
      child: TextField(
        controller: _searchController,
        onChanged: (val) => controller.setSearchQuery(val),
        decoration: InputDecoration(
          hintText: 'Search foods, dietary tags, or allergens (e.g. Halal, Wrap, GF)...',
          hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    controller.setSearchQuery('');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }

  Widget _buildDietaryFilterBar(CanteenController controller) {
    final selectedFilters = controller.selectedDietaryFilters;

    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 6),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "All" filter chip
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: const Text('All Foods'),
              selected: selectedFilters.isEmpty,
              onSelected: (_) => controller.clearDietaryFilters(),
              selectedColor: AppColors.primaryLight.withValues(alpha: 0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: selectedFilters.isEmpty ? FontWeight.bold : FontWeight.w500,
                color: selectedFilters.isEmpty ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),

          // Individual Dietary Preferences
          ...DietaryPreference.values.map((pref) {
            final isSelected = selectedFilters.contains(pref);
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FilterChip(
                avatar: Icon(pref.icon, size: 14, color: isSelected ? Colors.white : pref.color),
                label: Text(pref.displayName),
                selected: isSelected,
                selectedColor: pref.color,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
                backgroundColor: AppColors.surface,
                side: BorderSide(
                  color: isSelected ? pref.color : AppColors.border,
                ),
                onSelected: (_) => controller.toggleDietaryFilter(pref),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(CanteenController controller) {
    return Container(
      height: 38,
      margin: const EdgeInsets.only(bottom: 6),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _categoryTab(
            title: 'All Categories',
            isSelected: controller.selectedCategory == null,
            onTap: () => controller.setSelectedCategory(null),
          ),
          ...FoodCategory.values.map((cat) {
            return _categoryTab(
              title: cat.displayName,
              isSelected: controller.selectedCategory == cat,
              onTap: () => controller.setSelectedCategory(cat),
            );
          }),
        ],
      ),
    );
  }

  Widget _categoryTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(title),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          fontSize: 11.5,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : AppColors.textSecondary,
        ),
        backgroundColor: AppColors.surface,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
    );
  }

  Widget _buildMenuGrid(
    BuildContext context,
    CanteenController controller,
    List<FoodItem> items,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adapt grid column count based on available screen width
        final crossAxisCount = constraints.maxWidth > 900
            ? 3
            : constraints.maxWidth > 580
                ? 2
                : 1;

        if (crossAxisCount == 1) {
          // Mobile list view
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildItemCard(context, controller, items[index]);
            },
          );
        } else {
          // Responsive Grid for Tablets / Desktop
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.6,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildItemCard(context, controller, items[index]);
            },
          );
        }
      },
    );
  }

  Widget _buildItemCard(BuildContext context, CanteenController controller, FoodItem item) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => ItemDetailSheet.show(context, item, controller),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Emoji, Name, Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    alignment: Alignment.center,
                    child: Text(item.emoji, style: const TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${item.calories} kcal',
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Description
              Expanded(
                child: Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 8),

              // Dietary Badges Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: item.dietaryBadges.map((badge) {
                    return Container(
                      margin: const EdgeInsets.only(right: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badge.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(badge.icon, size: 10, color: badge.color),
                          const SizedBox(width: 3),
                          Text(
                            badge.shortCode,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: badge.color,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 10),

              // Action button row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Allergen quick preview
                  Expanded(
                    child: Text(
                      item.allergens.first.startsWith('None')
                          ? '✓ Allergen friendly'
                          : 'Allergens: ${item.allergens.join(", ")}',
                      style: TextStyle(
                        fontSize: 11,
                        color: item.allergens.first.startsWith('None')
                            ? AppColors.emerald
                            : AppColors.amber,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => ItemDetailSheet.show(context, item, controller),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Add', style: TextStyle(fontSize: 12.5)),
                        SizedBox(width: 4),
                        Icon(Icons.add, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(CanteenController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            const Text(
              'No items match your dietary filters',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try clearing some dietary filters or resetting your search term.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                _searchController.clear();
                controller.setSearchQuery('');
                controller.clearDietaryFilters();
                controller.setSelectedCategory(null);
              },
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Reset All Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCartBar(BuildContext context, CanteenController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${controller.cartCount} ${controller.cartCount == 1 ? "item" : "items"} in tray',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                Text(
                  '\$${controller.cartSubtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () => CartSheet.show(context, controller),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Tray & Checkout',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
