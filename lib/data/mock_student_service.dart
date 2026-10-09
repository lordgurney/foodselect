import '../domain/models/dietary_type.dart';
import '../domain/models/student.dart';

class StudentService {
  static final List<Student> _directory = [
    Student(
      id: 'S1042',
      fullName: 'Alex Morgan',
      grade: 10,
      homeroom: '10-B',
      medicalAllergies: const ['Peanuts', 'Tree Nuts'],
      preferredDietaryOptions: {DietaryPreference.nutFree},
      lunchAccountBalance: 25.50,
    ),
    Student(
      id: 'S2095',
      fullName: 'Fatima Al-Mansoor',
      grade: 11,
      homeroom: '11-C',
      medicalAllergies: const [],
      preferredDietaryOptions: {DietaryPreference.halal},
      lunchAccountBalance: 18.00,
    ),
    Student(
      id: 'S3114',
      fullName: 'Liam Chen',
      grade: 9,
      homeroom: '9-A',
      medicalAllergies: const ['Gluten (Celiac Disease)', 'Cow Milk'],
      preferredDietaryOptions: {
        DietaryPreference.glutenFree,
        DietaryPreference.dairyFree,
      },
      lunchAccountBalance: 40.00,
    ),
    Student(
      id: 'S4050',
      fullName: 'Zoe Washington',
      grade: 12,
      homeroom: '12-E',
      medicalAllergies: const [],
      preferredDietaryOptions: {
        DietaryPreference.vegetarian,
        DietaryPreference.vegan,
      },
      lunchAccountBalance: 12.75,
    ),
    Student(
      id: 'S5001',
      fullName: 'Jordan Taylor',
      grade: 10,
      homeroom: '10-D',
      medicalAllergies: const [],
      preferredDietaryOptions: {},
      lunchAccountBalance: 32.00,
    ),
  ];

  static List<Student> get sampleStudents => List.unmodifiable(_directory);

  /// Verifies a student ID. If found in sample directory, returns existing record.
  /// If not found, generates a valid student record for the school with default grade/homeroom.
  static Future<Student> verifyStudentId(String inputId) async {
    // Simulate brief network verification
    await Future.delayed(const Duration(milliseconds: 350));

    final normalized = inputId.trim().toUpperCase();
    if (normalized.isEmpty) {
      throw Exception('Please enter a valid Student ID number');
    }

    final match = _directory.where((s) => s.id.toUpperCase() == normalized);
    if (match.isNotEmpty) {
      return match.first;
    }

    // Dynamic fallback for any entered ID so user testing is never blocked!
    return Student(
      id: normalized.startsWith('S') ? normalized : 'S$normalized',
      fullName: 'Student ($normalized)',
      grade: 11,
      homeroom: '11-A',
      medicalAllergies: const [],
      preferredDietaryOptions: const {},
      lunchAccountBalance: 20.00,
    );
  }
}
