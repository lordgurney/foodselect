import 'dietary_type.dart';

class Student {
  final String id;
  final String fullName;
  final int grade;
  final String homeroom;
  final List<String> medicalAllergies;
  final Set<DietaryPreference> preferredDietaryOptions;
  final double lunchAccountBalance;

  const Student({
    required this.id,
    required this.fullName,
    required this.grade,
    required this.homeroom,
    required this.medicalAllergies,
    required this.preferredDietaryOptions,
    required this.lunchAccountBalance,
  });

  String get gradeAndHomeroom => 'Grade $grade • Room $homeroom';
}
