import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_student_service.dart';
import '../../domain/models/dietary_type.dart';
import '../../domain/models/meal_period.dart';
import '../../domain/models/student.dart';
import '../state/canteen_controller.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final CanteenController controller;

  const CheckoutScreen({super.key, required this.controller});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardExpiryController = TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();

  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller.verifiedStudent != null) {
      _studentIdController.text = widget.controller.verifiedStudent!.id;
      _cardNameController.text = widget.controller.verifiedStudent!.fullName;
    }
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }

  void _verifyStudent() async {
    final id = _studentIdController.text.trim();
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Student ID number')),
      );
      return;
    }

    final success = await widget.controller.verifyStudentId(id);
    if (success && mounted) {
      final student = widget.controller.verifiedStudent!;
      if (_cardNameController.text.isEmpty) {
        _cardNameController.text = student.fullName;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verified: ${student.fullName} (${student.gradeAndHomeroom})'),
          backgroundColor: AppColors.emerald,
        ),
      );
    }
  }

  void _fillDemoCard() {
    setState(() {
      if (_cardNameController.text.isEmpty) {
        _cardNameController.text = widget.controller.verifiedStudent?.fullName ?? 'Student Cardholder';
      }
      _cardNumberController.text = '4532 8901 2345 8821';
      _cardExpiryController.text = '08/28';
      _cardCvvController.text = '882';
    });
  }

  void _processPayment() async {
    if (widget.controller.verifiedStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please verify your Student ID first.')),
      );
      return;
    }

    if (_cardNumberController.text.trim().length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid card details.')),
      );
      return;
    }

    setState(() => _isProcessingPayment = true);

    // Simulate secure transaction
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    final cardNum = _cardNumberController.text.replaceAll(' ', '');
    final lastFour = cardNum.length >= 4 ? cardNum.substring(cardNum.length - 4) : '4242';

    final order = widget.controller.placeOrder(cardLastFour: lastFour);

    setState(() => _isProcessingPayment = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(
          order: order,
          controller: widget.controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final verifiedStudent = widget.controller.verifiedStudent;
        final warnings = widget.controller.getDietaryAllergyWarnings();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Checkout & Verification'),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Step Indicator
                    _buildStepIndicator(isStudentVerified: verifiedStudent != null),
                    const SizedBox(height: 24),

                    // STEP 1: Student Verification Box
                    _buildStudentVerificationSection(verifiedStudent),
                    const SizedBox(height: 20),

                    // Allergy Cross-Check Warnings (if applicable)
                    if (verifiedStudent != null && warnings.isNotEmpty) ...[
                      _buildAllergyWarningCard(warnings),
                      const SizedBox(height: 20),
                    ],

                    // STEP 2: Card Payment Section (Unlocked after Student Verification)
                    _buildCardPaymentSection(isUnlocked: verifiedStudent != null),
                    const SizedBox(height: 20),

                    // Order Summary Box
                    _buildOrderSummaryBox(),
                    const SizedBox(height: 24),

                    // Submit Payment Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: verifiedStudent != null ? AppColors.emerald : AppColors.primary,
                      ),
                      onPressed: verifiedStudent != null && !_isProcessingPayment
                          ? _processPayment
                          : null,
                      child: _isProcessingPayment
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock_outline, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  verifiedStudent != null
                                      ? 'Pay \$${widget.controller.cartSubtotal.toStringAsFixed(2)} with Card'
                                      : 'Verify Student ID to Continue',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shield_outlined, size: 14, color: AppColors.textMuted),
                          SizedBox(width: 4),
                          Text(
                            'High School Canteen Secure Payment • 256-bit Encrypted',
                            style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepIndicator({required bool isStudentVerified}) {
    return Row(
      children: [
        _stepCircle(1, 'Verify ID', true),
        Expanded(
          child: Container(
            height: 2,
            color: isStudentVerified ? AppColors.emerald : AppColors.border,
          ),
        ),
        _stepCircle(2, 'Pay with Card', isStudentVerified),
        Expanded(
          child: Container(
            height: 2,
            color: AppColors.border,
          ),
        ),
        _stepCircle(3, 'Pickup Ticket', false),
      ],
    );
  }

  Widget _stepCircle(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : AppColors.surfaceSubtle,
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.border,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$step',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentVerificationSection(Student? student) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.badge_outlined, color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Step 1: Student Verification',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const Spacer(),
                if (student != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.emerald.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 14, color: AppColors.emerald),
                        SizedBox(width: 4),
                        Text('Verified', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.emerald)),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Enter your 5-digit Student ID to link your order to school homeroom and verify dietary safety:',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),

            // Input Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _studentIdController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'e.g. S1042',
                      prefixIcon: const Icon(Icons.tag, size: 18),
                      filled: true,
                      fillColor: AppColors.surfaceSubtle,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                    onSubmitted: (_) => _verifyStudent(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: widget.controller.isVerifyingStudent ? null : _verifyStudent,
                  child: widget.controller.isVerifyingStudent
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Verify ID'),
                ),
              ],
            ),

            if (widget.controller.verificationError != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.controller.verificationError!,
                style: const TextStyle(fontSize: 12, color: AppColors.rose),
              ),
            ],

            const SizedBox(height: 12),
            const Text(
              'Quick test student profiles:',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textMuted),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: StudentService.sampleStudents.map((s) {
                final isSelected = student?.id == s.id;
                String tag = '';
                if (s.medicalAllergies.isNotEmpty) {
                  tag = ' (${s.medicalAllergies.first})';
                } else if (s.preferredDietaryOptions.isNotEmpty) {
                  tag = ' (${s.preferredDietaryOptions.first.displayName})';
                }

                return ActionChip(
                  backgroundColor: isSelected ? AppColors.primaryLight.withValues(alpha: 0.15) : AppColors.surfaceSubtle,
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                  label: Text(
                    '${s.id} • ${s.fullName.split(" ").first}$tag',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  onPressed: () {
                    _studentIdController.text = s.id;
                    widget.controller.setStudentDirectly(s);
                    _cardNameController.text = s.fullName;
                  },
                );
              }).toList(),
            ),

            // Verified Student Card
            if (student != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          student.fullName,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        Text(
                          student.gradeAndHomeroom,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.health_and_safety_outlined, size: 15, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            student.medicalAllergies.isEmpty
                                ? 'No medical allergies on school record'
                                : 'School Allergy Record: ${student.medicalAllergies.join(", ")}',
                            style: TextStyle(
                              fontSize: 12,
                              color: student.medicalAllergies.isEmpty ? AppColors.textSecondary : AppColors.amber,
                              fontWeight: student.medicalAllergies.isEmpty ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAllergyWarningCard(List<String> warnings) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFCD34D), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFB45309), size: 20),
              SizedBox(width: 8),
              Text(
                'High School Dietary & Allergy Safety Notice',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF92400E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...warnings.map(
            (w) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                '• $w',
                style: const TextStyle(fontSize: 12, color: Color(0xFF78350F)),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Special Prep: This order will automatically route to Counter 3 (Allergen-Safe Prep Counter).',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF92400E)),
          ),
        ],
      ),
    );
  }

  Widget _buildCardPaymentSection({required bool isUnlocked}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.credit_card, color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Step 2: Pay with Card',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: isUnlocked ? _fillDemoCard : null,
                  icon: const Icon(Icons.auto_fix_high, size: 14),
                  label: const Text('Fill Test Card', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter card details for payment confirmation:',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),

            // Cardholder Name
            TextField(
              controller: _cardNameController,
              enabled: isUnlocked,
              decoration: InputDecoration(
                labelText: 'Name on Card',
                prefixIcon: const Icon(Icons.person_outline, size: 18),
                filled: true,
                fillColor: isUnlocked ? AppColors.surfaceSubtle : AppColors.border.withValues(alpha: 0.3),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Card Number
            TextField(
              controller: _cardNumberController,
              enabled: isUnlocked,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '4532 •••• •••• 4242',
                prefixIcon: const Icon(Icons.payment, size: 18),
                filled: true,
                fillColor: isUnlocked ? AppColors.surfaceSubtle : AppColors.border.withValues(alpha: 0.3),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Expiry & CVV Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cardExpiryController,
                    enabled: isUnlocked,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'Expiry (MM/YY)',
                      hintText: '08/28',
                      prefixIcon: const Icon(Icons.calendar_today_outlined, size: 16),
                      filled: true,
                      fillColor: isUnlocked ? AppColors.surfaceSubtle : AppColors.border.withValues(alpha: 0.3),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cardCvvController,
                    enabled: isUnlocked,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      prefixIcon: const Icon(Icons.lock_outline, size: 16),
                      filled: true,
                      fillColor: isUnlocked ? AppColors.surfaceSubtle : AppColors.border.withValues(alpha: 0.3),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Scheduled Meal Period', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text(
                widget.controller.selectedMealPeriod.title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Items in Tray', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text(
                '${widget.controller.cartCount} items',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Divider(height: 16, color: AppColors.border),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount Payable', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text(
                '\$${widget.controller.cartSubtotal.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
