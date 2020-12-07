import 'package:flutter/foundation.dart';
import 'package:halpla/src/models/activeDay.dart';

class Cat {
  String id;
  String name;
  List<ActiveDay> past7DaysOfSteps;
  int equippedItemId;
  String pushToken;
  String country;
  Cat(
      {@required this.name,
      this.id,
      this.country,
      this.past7DaysOfSteps,
      this.pushToken,
      this.equippedItemId});
  DateTime get lastUpdatedSteps => past7DaysOfSteps.length > 0
      ? past7DaysOfSteps[past7DaysOfSteps.length - 1].date
      : null;

  int stepsCoveredSinceDate(DateTime startDate) {
    int totalSteps = 0;
    past7DaysOfSteps.forEach((s) {
      if (s.date.isAfter(startDate)) {
        totalSteps += s.stepsTracked;
      }
    });
    return totalSteps;
  }

  int get isFat {
    // past7DaysOfSteps.forEach((s) {
    //   if (s.stepsTracked <= 100) {
    //     print("This Cat is Fat");
    //     return 1;
    //   }
    // });
    // return 0;
    int totalSteps = 0;
    past7DaysOfSteps.forEach((ActiveDay exerciseDay) {
      if (DateTime.now().difference(exerciseDay.date).inDays < 8) {
        totalSteps += exerciseDay.stepsTracked;
      }
    });
    return totalSteps <= 100 ? 1 : 0;
  }
}
