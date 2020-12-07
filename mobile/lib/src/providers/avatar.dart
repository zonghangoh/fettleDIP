import 'package:flutter/widgets.dart';
import 'package:halpla/src/models/activeDay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../providers/auth.dart';
import 'package:health/health.dart';
import '../helpers/doctor.dart';
import '../models/cat.dart';

class AvatarProvider with ChangeNotifier {
  AuthProvider auth;
  bool onboarded;
  String name;
  int stepsToday = 0;
  List<ActiveDay> past7DaysOfSteps = [];
  int stepsSinceBirth = 0;
  int bonusCoins = 0;
  int coinsSpent = 0;
  DateTime lastUpdated;
  bool promptConnectionToHealthApp = false;
  String country = 'Singapore';
  HealthFactory health = HealthFactory();
  List<String> friendIds = [];
  List<int> itemIds = [];
  int equippedItemId = 0;
  List<DateTime> upcomingTabataDates = [];

  DateTime lastCollectedRewardAt;

  int get coinsLeft =>
      (stepsSinceBirth / 1000).floor() * 5 -
      coinsSpent +
      bonusCoins; // for every 1000 steps taken, 5 coins are awarded.
  int get averageStepsPerDay => (past7DaysOfSteps.length > 0)
      ? (past7DaysOfSteps.fold(
                  0, (value, element) => value + element.stepsTracked) /
              past7DaysOfSteps.length)
          .round()
      : 0;
  Cat get myCat => Cat(
      name: name,
      id: auth.userId,
      past7DaysOfSteps: past7DaysOfSteps,
      equippedItemId: equippedItemId);

  void completeQuest(int coins) {
    FirebaseFirestore.instance.collection('avatars').doc(auth.userId).update({
      'lastCollectedRewardAt': DateTime.now().millisecondsSinceEpoch,
      'bonusCoins': FieldValue.increment(coins),
    }).catchError((onError) {
      print(onError);
    });
    lastCollectedRewardAt = DateTime.now();
    notifyListeners();
  }

  Future fetchBioData() async {
    print("fetching bio data");
    try {
      DocumentSnapshot avatarDocument = await FirebaseFirestore.instance
          .collection('avatars')
          .doc(auth.userId)
          .get();
      if (avatarDocument.data() == null) {
        lastUpdated = DateTime.now().subtract(Duration(days: 7));
        onboarded = false;
        stepsSinceBirth = 0;
        bonusCoins = 0;
        lastCollectedRewardAt = DateTime.now().subtract(Duration(days: 30));
      } else {
        lastCollectedRewardAt = DateTime.fromMillisecondsSinceEpoch(
            avatarDocument.data()['lastCollectedRewardAt'] ??
                DateTime.now()
                    .subtract(Duration(days: 30))
                    .millisecondsSinceEpoch);
        bonusCoins = avatarDocument.data()['bonusCoins'] ?? 0;
        itemIds = List.from(avatarDocument.data()['itemIds']) ?? [];
        equippedItemId = avatarDocument.data()['equippedItemId'] ?? 0;
        stepsToday = avatarDocument.data()['stepsToday'] ?? 0;
        name = avatarDocument.data()['name'] ?? '';
        coinsSpent = avatarDocument.data()['coinsSpent'] ?? 0;
        country = avatarDocument.data()['country'] ?? 'Singapore';
        stepsSinceBirth = avatarDocument.data()['stepsSinceBirth'].toInt() ?? 0;
        friendIds = List.from(avatarDocument.data()['friendIds'] ?? []) ?? [];
        lastUpdated = DateTime.fromMillisecondsSinceEpoch(
            avatarDocument.data()['lastUpdated'] ??
                DateTime.now().millisecondsSinceEpoch);
        updateSteps();
        onboarded = true;
      }
      return;
    } catch (e) {
      print(e);
    }
  }

  // jeral
  // how to update documents from firestore

  Future updateSteps({bool forceDatabaseUpdate = false}) async {
    List<HealthDataType> types = [HealthDataType.STEPS];

    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        DateTime.now().subtract(Duration(days: 7)), DateTime.now(), types);
    // print(
    //     "updating steps with " + healthData.length.toString() + " datapoints");
    past7DaysOfSteps = Doctor.parseActiveDays(healthData);
    int stepsTodayTemp = (past7DaysOfSteps.length > 0 &&
            past7DaysOfSteps[past7DaysOfSteps.length - 1].date.day ==
                DateTime.now().day)
        ? past7DaysOfSteps[past7DaysOfSteps.length - 1].stepsTracked
        : 0;

    if (forceDatabaseUpdate || stepsTodayTemp != stepsToday) {
      // print('update database with ' +
      //     newHealthData.length.toString() +
      //     ' datapoints');
      if (lastUpdated.day ==
              past7DaysOfSteps[past7DaysOfSteps.length - 1].date.day &&
          lastUpdated.month ==
              past7DaysOfSteps[past7DaysOfSteps.length - 1].date.month) {
        // has updated on same day
        if (stepsTodayTemp > stepsToday) {
          int increaseInSteps = stepsTodayTemp - stepsToday;
          stepsToday = stepsTodayTemp;
          lastUpdated = DateTime.now();
          FirebaseFirestore.instance
              .collection('avatars')
              .doc(auth.userId)
              .update({
            'lastUpdated': DateTime.now().millisecondsSinceEpoch,
            'stepsToday': stepsToday,
            'stepsSinceBirth': FieldValue.increment(increaseInSteps),
            'past7Days': past7DaysOfSteps.map((day) {
              return {
                'timeStamp': day.date.millisecondsSinceEpoch,
                'stepsTracked': day.stepsTracked
              };
            }).toList()
          }).catchError((onError) {
            print(onError);
          });
          stepsSinceBirth += increaseInSteps;
        }
      } else {
        // not updated today
        List<HealthDataPoint> newHealthData =
            healthData.where((hd) => hd.dateTo.isAfter(lastUpdated)).toList();

        List<HealthDataPoint> todayHealthData = newHealthData
            .where((hd) =>
                hd.dateFrom.day == DateTime.now().day &&
                hd.dateFrom.month == DateTime.now().month)
            .toList();
        stepsToday = todayHealthData.fold(
            0, (value, element) => value + element.value.toInt());
        lastUpdated = DateTime.now();
        print('update database');
        FirebaseFirestore.instance
            .collection('avatars')
            .doc(auth.userId)
            .update({
          'lastUpdated': DateTime.now().millisecondsSinceEpoch,
          'stepsToday': stepsToday,
          'stepsSinceBirth': FieldValue.increment(newHealthData.fold(
              0, (value, element) => value + element.value.toInt())),
          'past7Days': past7DaysOfSteps.map((day) {
            return {
              'timeStamp': day.date.millisecondsSinceEpoch,
              'stepsTracked': day.stepsTracked
            };
          }).toList()
        }).catchError((onError) {
          print(onError);
        });
        stepsSinceBirth += newHealthData
            .fold(0, (value, element) => value + element.value)
            .toInt();
      }
    }

    // stepsToday = 1500;
    promptConnectionToHealthApp = false;
    notifyListeners();
    return;
  }

  void flyToCountry(String country, int coins) {
    this.country = country;
    coinsSpent += coins;
    FirebaseFirestore.instance.collection('avatars').doc(auth.userId).update(
      {'coinsSpent': FieldValue.increment(coins), 'country': country},
    );

    // Automatic flyback to Singapore
    Future.delayed(const Duration(days: 7), () {
      this.country = 'Singapore';
      FirebaseFirestore.instance.collection('avatars').doc(auth.userId).update(
        {'country': 'Singapore'},
      );
    });

    // jeral: how to update arrays in firestore
    // FieldValue.increment(coins)
    // FieldValue.arrayRemove([])
    // FieldValue.arrayUnion([])
    // jeral: how to use set instead of update (but need to use merge if want to retain old field values)
    // FirebaseFirestore.instance.collection('avatars').doc(auth.userId).set(
    //     {'coinsSpent': FieldValue.increment(coins), 'country': country},
    //     SetOptions(merge: true));
    notifyListeners();
    return;
  }

  void buyItem(int itemId, int coins) {
    // change string to int, costume to id
    this.itemIds.add(itemId);
    coinsSpent += coins;
    FirebaseFirestore.instance.collection('avatars').doc(auth.userId).update(
        {'coinsSpent': FieldValue.increment(coins), 'itemIds': itemIds});
  }

  void equipItem(int itemId) {
    this.equippedItemId = itemId;
    FirebaseFirestore.instance
        .collection('avatars')
        .doc(auth.userId)
        .update({'equippedItemId': equippedItemId});
    notifyListeners();
  }

  void useVoucher(int itemId) {
    // change string to int, costume to id
    this.itemIds.remove(itemId);
    FirebaseFirestore.instance
        .collection('avatars')
        .doc(auth.userId)
        .update({'itemIds': itemIds});
  }

  // jeral: make itemIds array
  Future saveBioData(String name) async {
    this.name = name;
    await FirebaseFirestore.instance
        .collection('avatars')
        .doc(auth.userId)
        .set({
      'name': name,
      'past7Days': [],
      'stepsSinceBirth': 0,
      'coinsSpent': 0,
      'bonusCoins': 0,
      'country': 'Singapore',
      'friendIds': [],
      'itemIds': []
    }, SetOptions(merge: true));
    onboarded = true;
    promptConnectionToHealthApp = false;
    notifyListeners();
  }

  void forceNotifyListeners() {
    notifyListeners();
  }

  void update(AuthProvider auth) => this.auth = auth;
}
