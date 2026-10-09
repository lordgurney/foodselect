import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/meal_period.dart';
import '../../domain/models/order.dart';
import '../state/canteen_controller.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final CafeteriaOrder order;
  final CanteenController controller;

  const OrderConfirmationScreen({
    super.key,
    required this.order,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmed'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Return to Menu',
            onPressed: () {
              controller.startNewOrder();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Success Badge
                Center(
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: AppColors.emerald.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.emerald, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 48),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Order Received by Canteen!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Your meal is scheduled for ${order.mealPeriod.title}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Digital Pickup Ticket Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Order Number & Time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PICKUP TICKET',
                                  style: TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  order.orderId,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                order.mealPeriod.timeSlot,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Special Dietary Callout / Counter Box
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: order.hasSpecialDietaryPrep
                                ? const Color(0xFFFFFBEB)
                                : const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: order.hasSpecialDietaryPrep
                                  ? const Color(0xFFFDE68A)
                                  : const Color(0xFFBBF7D0),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                order.hasSpecialDietaryPrep
                                    ? Icons.shield_outlined
                                    : Icons.storefront_outlined,
                                color: order.hasSpecialDietaryPrep
                                    ? AppColors.amber
                                    : AppColors.emerald,
                                size: 28,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order.hasSpecialDietaryPrep
                                          ? 'SPECIAL DIETARY SERVICE COUNTER'
                                          : 'PICKUP WINDOW',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                        color: order.hasSpecialDietaryPrep
                                            ? const Color(0xFF92400E)
                                            : const Color(0xFF166534),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      order.pickupCounter,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: order.hasSpecialDietaryPrep
                                            ? const Color(0xFF78350F)
                                            : const Color(0xFF14532D),
                                      ),
                                    ),
                                    if (order.hasSpecialDietaryPrep) ...[
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Allergen meals are prepped separately with dedicated utensils and tagged with your Student ID.',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF92400E),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Student Details & School Info
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Student Name', style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                                  Text(
                                    order.student.fullName,
                                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Student ID / Room', style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                                  Text(
                                    '${order.student.id} • ${order.student.gradeAndHomeroom}',
                                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        const Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: 16),

                        // Itemized Breakdown
                        const Text(
                          'Items Ordered',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...order.items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${item.quantity}x ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.foodItem.name, style: const TextStyle(fontSize: 13)),
                                      if (item.specialDietaryNotes.isNotEmpty)
                                        Text(
                                          'Note: ${item.specialDietaryNotes}',
                                          style: const TextStyle(fontSize: 11, color: AppColors.amber, fontWeight: FontWeight.w500),
                                        ),
                                    ],
                                  ),
                                ),
                                Text('\$${item.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 14),
                        const Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: 14),

                        // Payment info & Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.credit_card, size: 18, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Text(
                                  'Paid via Card (•••• ${order.cardLastFour})',
                                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            Text(
                              'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Barcode representation for scanner
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: [
                              // Visual barcode bars
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(36, (i) {
                                  final isThick = (i % 3 == 0) || (i % 7 == 0);
                                  final isTall = (i % 5 != 0);
                                  return Container(
                                    width: isThick ? 4 : 2,
                                    height: isTall ? 36 : 28,
                                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                    color: Colors.black87,
                                  );
                                }),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '* ${order.orderId} - ${order.student.id} *',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                  letterSpacing: 1.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Scan this barcode at the canteen collection counter',
                                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Return to Home button
                ElevatedButton(
                  onPressed: () {
                    controller.startNewOrder();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('Back to Canteen Menu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
