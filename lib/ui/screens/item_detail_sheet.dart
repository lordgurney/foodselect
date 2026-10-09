import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/dietary_type.dart';
import '../../domain/models/food_item.dart';
import '../state/canteen_controller.dart';

class ItemDetailSheet extends StatefulWidget {
  final FoodItem item;
  final CanteenController controller;

  const ItemDetailSheet({
    super.key,
    required this.item,
    required this.controller,
  });

  static Future<void> show(BuildContext context, FoodItem item, CanteenController controller) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ItemDetailSheet(item: item, controller: controller),
    );
  }

  @override
  State<ItemDetailSheet> createState() => _ItemDetailSheetState();
}

class _ItemDetailSheetState extends State<ItemDetailSheet> {
  int _quantity = 1;
  final Map<String, CustomizationOption> _singleSelections = {};
  final Set<CustomizationOption> _multipleSelections = {};
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-select required customization options
    for (final group in widget.item.customizationGroups) {
      if (group.isRequired && group.options.isNotEmpty) {
        _singleSelections[group.groupName] = group.options.first;
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _currentUnitPrice {
    double unit = widget.item.price;
    for (final opt in _singleSelections.values) {
      unit += opt.extraPrice;
    }
    for (final opt in _multipleSelections) {
      unit += opt.extraPrice;
    }
    return unit;
  }

  double get _totalPrice => _currentUnitPrice * _quantity;

  List<CustomizationOption> get _allSelectedCustomizations {
    return [..._singleSelections.values, ..._multipleSelections];
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: media.size.height * 0.88,
        maxWidth: 640,
      ),
      margin: EdgeInsets.only(
        left: media.size.width > 680 ? (media.size.width - 640) / 2 : 0,
        right: media.size.width > 680 ? (media.size.width - 640) / 2 : 0,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                // Top Header with Emoji Art & Close button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.item.emoji,
                        style: const TextStyle(fontSize: 38),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.name,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                '\$${widget.item.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceSubtle,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${widget.item.calories} kcal',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Description
                Text(
                  widget.item.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 16),

                // Dietary Badges Row
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.item.dietaryBadges.map((badge) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badge.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: badge.color.withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(badge.icon, size: 14, color: badge.color),
                          const SizedBox(width: 4),
                          Text(
                            badge.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: badge.color,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Allergen Statement Callout
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFCA5A5).withValues(alpha: 0.6)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFFDC2626), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Allergen Information',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF991B1B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Contains: ${widget.item.allergens.join(", ")}',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF7F1D1D),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Customization Groups
                if (widget.item.customizationGroups.isNotEmpty) ...[
                  for (final group in widget.item.customizationGroups) ...[
                    Text(
                      group.groupName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (group.allowsMultiple)
                      // Multiple selection
                      Column(
                        children: group.options.map((opt) {
                          final isOptionChecked = _multipleSelections.contains(opt);
                          return CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(opt.title, style: const TextStyle(fontSize: 14)),
                            subtitle: opt.extraPrice > 0
                                ? Text('+ \$${opt.extraPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(color: AppColors.primary, fontSize: 12))
                                : null,
                            value: isOptionChecked,
                            activeColor: AppColors.primary,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _multipleSelections.add(opt);
                                } else {
                                  _multipleSelections.remove(opt);
                                }
                              });
                            },
                          );
                        }).toList(),
                      )
                    else
                      // Single selection (Radio)
                      Column(
                        children: group.options.map((opt) {
                          final isSelected = _singleSelections[group.groupName] == opt;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _singleSelections[group.groupName] = opt;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                    size: 20,
                                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          opt.title,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                          ),
                                        ),
                                        if (opt.extraPrice > 0)
                                          Text(
                                            '+ \$${opt.extraPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(color: AppColors.primary, fontSize: 12),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (opt.dietaryImpact != null) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: opt.dietaryImpact!.color.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        opt.dietaryImpact!.displayName,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: opt.dietaryImpact!.color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 12),
                  ],
                ],

                // Special Dietary Note for Kitchen
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.shield_outlined, size: 16, color: AppColors.amber),
                    SizedBox(width: 6),
                    Text(
                      'Dietary Notes / Allergy Instructions for Canteen Staff',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'e.g. Severe peanut allergy; pack in separate sealed bag; no mayo',
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.surfaceSubtle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'ℹ️ Canteen staff prepare verified allergy orders at dedicated prep stations with clean utensils.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),

          // Bottom sticky action bar with quantity & add to cart
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: const Border(top: BorderSide(color: AppColors.border)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Quantity Stepper
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: _quantity > 1
                            ? () {
                                setState(() => _quantity--);
                              }
                            : null,
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () {
                          setState(() => _quantity++);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                // Add to Cart Button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      widget.controller.addToCart(
                        foodItem: widget.item,
                        quantity: _quantity,
                        customizations: _allSelectedCustomizations,
                        specialNotes: _notesController.text,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added ${widget.item.name} to order'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_bag_outlined, size: 18),
                        const SizedBox(width: 8),
                        Text('Add to Order • \$${_totalPrice.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
