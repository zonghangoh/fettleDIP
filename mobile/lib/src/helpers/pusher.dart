import '../models/cat.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Pusher {
  static void sendNotification({
    String title,
    String message,
    String peerPushToken,
  }) async {
    final String serverToken = '';
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': message, 'title': title},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': peerPushToken
        },
      ),
    );
  }

  static void sendExerciseInvites(List<Cat> friends, String id, String name,
      String channelName, DateTime tentativeStartsAt) async {
    final String serverToken = '';
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );

    friends.forEach((cat) {
      String groupChatId;
      if (id.compareTo(cat.id) == -1) {
        groupChatId = id + '-' + cat.id;
      } else {
        groupChatId = cat.id + '-' + id;
      }

      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      var documentReference = FirebaseFirestore.instance
          .collection('chatlog')
          .doc(groupChatId)
          .collection('messages')
          .doc(timeStamp.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        //  transaction.delete
        transaction.set(
          documentReference,
          {
            'from': id,
            'to': cat.id,
            'nameFrom': name,
            'timestamp': timeStamp,
            'content': 'WORKOUT REQUEST',
            'channelName': channelName,
            'startsAt': tentativeStartsAt.millisecondsSinceEpoch,
            'type': 1,
            'response': 0,
            'read': false
          },
        );
      }).then((value) {});

      FirebaseFirestore.instance.collection("chatlog").doc(groupChatId).set({
        'lastSentAt': DateTime.now().millisecondsSinceEpoch,
        'cats': [id, cat.id]
      }, SetOptions(merge: true));

      FirebaseFirestore.instance.collection('presence').doc(cat.id).update({
        'newFrom': FieldValue.arrayUnion([id])
      });
      http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': "Workout with me leh.",
              'title': name
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': cat.pushToken
          },
        ),
      );
    });
  }

  static void sendAndRetrieveMessage() async {
    final String serverToken = '';
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': await firebaseMessaging.getToken(),
        },
      ),
    );
  }
}
