enum MealPeriod {
  recess,
  lunch,
}

extension MealPeriodExtension on MealPeriod {
  String get title {
    switch (this) {
      case MealPeriod.recess:
        return 'Morning Recess';
      case MealPeriod.lunch:
        return 'Lunch Break';
    }
  }

  String get timeSlot {
    switch (this) {
      case MealPeriod.recess:
        return '10:45 AM - 11:15 AM';
      case MealPeriod.lunch:
        return '1:10 PM - 1:55 PM';
    }
  }

  String get orderCutoff {
    switch (this) {
      case MealPeriod.recess:
        return 'Cut-off: 9:30 AM';
      case MealPeriod.lunch:
        return 'Cut-off: 11:30 AM';
    }
  }
}
