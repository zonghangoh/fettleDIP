import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth.dart';
import '../helpers/gym.dart';
import '../models/exerciseDay.dart';

class ExerciseProvider with ChangeNotifier {
  AuthProvider auth;
  List<ExerciseDay> exerciseDays = [];
  int latestCallerId = 0;

  List<ExerciseDay> get exerciseDaysOrganisedByMe => exerciseDays
      .where((exerciseDay) => exerciseDay.packLeader == auth.userId)
      .toList();

  List<ExerciseDay> get exerciseDaysJoinedByMe => exerciseDays
      .where((exerciseDay) =>
          exerciseDay.packLeader != auth.userId &&
          exerciseDay.friendIds.contains(auth.userId))
      .toList();

  List<ExerciseDay> get exerciseDaysJioedByFriends => exerciseDays
      .where((exerciseDay) => exerciseDay.packLeader != auth.userId)
      .toList();

  // List<ExerciseDay> get exerciseDaysOpenJioedByFriends => exerciseDays;

  Future fetchExerciseDays(List<String> friendIds) async {
    QuerySnapshot exerciseQueries = await FirebaseFirestore.instance
        .collection('workoutRooms')
        .where('hostedBy',
            whereIn: friendIds.length > 0
                ? [...friendIds, auth.userId]
                : [auth.userId])
        .where('completed', isNull: true)
        // .where('scheduledAt',
        //     isLessThan:
        //         DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch)
        .get()
        .catchError((onError) => print(onError));

    List<QueryDocumentSnapshot> exerciseDaySnapshots = exerciseQueries.docs;

    exerciseDays = exerciseDaySnapshots.map((exerciseDocument) {
      ExerciseDay exDay = ExerciseDay(
          scheduledAt: DateTime.fromMillisecondsSinceEpoch(
              exerciseDocument.data()['scheduledAt']),
          friendIds: exerciseDocument.data()['participants'].cast<String>(),
          channelName: exerciseDocument.data()['channelName'],
          startedAt: exerciseDocument.data()['startedAt'] == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(
                  exerciseDocument.data()['startedAt']),
          packLeader: exerciseDocument.data()['hostedBy'],
          isPrivate: !exerciseDocument.data()['openJio']);
      return exDay;
    }).toList();
    exerciseDays.sort((a, b) {
      return a.scheduledAt.isAfter(b.scheduledAt) ? 1 : -1;
    });
    return;
  }

  void ignoreJio(String workoutRoomId) {
    Gym.leaveWorkoutRoom(workoutRoomId);
    exerciseDays.removeWhere((ExerciseDay day) {
      return day.channelName == workoutRoomId;
    });
    notifyListeners();
  }

  String createExerciseDay(
      {DateTime scheduledAt, List<String> friendIds, bool openJio: false}) {
    FirebaseAuth _fAuth = FirebaseAuth.instance;
    String channelName =
        _fAuth.currentUser.uid + scheduledAt.millisecondsSinceEpoch.toString();
    Gym.createWorkoutRoom(channelName, scheduledAt, openJio: openJio);
    exerciseDays.add(ExerciseDay(
        isPrivate: !openJio,
        friendIds: [auth.userId],
        scheduledAt: scheduledAt,
        packLeader: auth.userId,
        channelName: channelName));
    notifyListeners();
    return channelName;
  }

  void rvsp(String id) {
    exerciseDays
        .firstWhere((element) => element.packLeader == id)
        .friendIds
        .add(auth.userId);
    notifyListeners();
  }

  void update(AuthProvider auth) => this.auth = auth;
}
