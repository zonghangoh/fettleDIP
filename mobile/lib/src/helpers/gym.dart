import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Gym {
  static Future<String> getWorkoutRoomToken(
      {int id = 0, String channelName = 'Zong Han'}) async {
    dynamic response = await http.get(
      'https://kampung-api.herokuapp.com?uid=' +
          id.toString() +
          '&channelName=' +
          channelName,
    );
    return json.decode(response.body)['token'];
  }

  static createWorkoutRoom(String channelName, DateTime scheduledAt,
      {bool openJio: false}) {
    FirebaseAuth _fAuth = FirebaseAuth.instance;
    FirebaseFirestore.instance.collection('workoutRooms').doc(channelName).set({
      'openJio': openJio,
      'channelName': channelName,
      'participants': [_fAuth.currentUser.uid],
      'hostedBy': _fAuth.currentUser.uid,
      'scheduledAt': scheduledAt.millisecondsSinceEpoch,
      'startedAt': null,
      'completed': null,
      'usersWhoCollectedReward': []
    });
  }

  static rvsp(String channelName) {
    FirebaseAuth _fAuth = FirebaseAuth.instance;
    FirebaseFirestore.instance
        .collection('workoutRooms')
        .doc(channelName)
        .update({
      'participants': FieldValue.arrayUnion([_fAuth.currentUser.uid]),
    });
  }

  static leaveWorkoutRoom(String workoutRoomId) {
    FirebaseAuth _fAuth = FirebaseAuth.instance;
    FirebaseFirestore.instance
        .collection('workoutRooms')
        .doc(workoutRoomId)
        .update({
      'participants': FieldValue.arrayRemove([_fAuth.currentUser.uid]),
    });
  }
}
