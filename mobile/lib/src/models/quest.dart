import 'cat.dart';

class Quest {
  DateTime startDate;
  DateTime endDate;
  int minimumFriends;
  int minimumStepsEach;
  int coinReward;
  Quest(
      {this.startDate,
      this.endDate,
      this.minimumStepsEach,
      this.minimumFriends});
  Quest.testQuest() {
    this.startDate =
        DateTime.now().subtract(new Duration(days: DateTime.now().weekday));
    this.endDate = DateTime.now()
        .subtract(new Duration(days: DateTime.now().weekday))
        .add(Duration(days: 6));
    this.minimumFriends = 2;
    this.minimumStepsEach = 5000;
    this.coinReward = 200;
  }

  bool hasCompletedQuest(List<Cat> cats) {
    Cat lazyCat = cats.firstWhere((cat) {
      int totalSteps = 0;
      cat.past7DaysOfSteps.forEach((s) {
        if (s.date.isAfter(startDate)) {
          totalSteps += s.stepsTracked;
        }
      });
      return totalSteps < minimumStepsEach;
    }, orElse: () => null);
    return lazyCat == null;
  }

  bool isEligibleForQuest(List<Cat> friends) =>
      friends.length >= minimumFriends;
}
