import 'package:flutter/widgets.dart';
import 'package:halpla/src/models/activeDay.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../providers/auth.dart';
import '../helpers/pusher.dart';
import '../models/cat.dart';
import '../models/notification.dart';
import '../models/activeDay.dart';

class FriendsProvider with ChangeNotifier {
  AuthProvider auth;
  List<Cat> friendAvatars = [];
  List<Cat> workoutBuddyAvatars = [];
  Future<Cat> findAFriend(String username) async {
    DocumentSnapshot avatarDocument = await FirebaseFirestore.instance
        .collection('avatars')
        .doc(auth.userId)
        .get();
    if (avatarDocument.data()['name'] != username) {
      QuerySnapshot friend = await FirebaseFirestore.instance
          .collection('avatars')
          .where("name", isEqualTo: username)
          .limit(1)
          .get()
          .catchError((e) {});
      if (friend.docs.length == 1) {
        Cat pengYou = Cat(
            id: friend.docs[0].id,
            pushToken: friend.docs[0].data()['pushToken'] ?? '',
            name: friend.docs[0].data()['name'],
            past7DaysOfSteps: [],
            equippedItemId: 0);
        return pengYou;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  void sendPet(String id, String avatarName, Cat peer) async {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(id)
        .collection('notifications')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      'read': false,
      'type': FettleNotification.returnStringFromNotificationType(
          NotificationType.Petted),
      'title': avatarName + " has petted you!",
      'subtitle': "Time to walk and exercise more",
      'body': json.encode({'peerId': peer.pushToken}),
      'action': 0,
    });
    Pusher.sendNotification(
        title: avatarName + " has petted you!",
        message: 'pet pet muddafaka',
        peerPushToken: peer.pushToken);
  }

  void sendFriendRequest(String id, String avatarName) async {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(id)
        .collection('notifications')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      'read': false,
      'type': FettleNotification.returnStringFromNotificationType(
          NotificationType.FriendRequest),
      'title': avatarName + " has sent you a friend request!",
      'subtitle': "This could be the start of something special.",
      'body': json.encode({'peerId': auth.userId}),
      'action': 0,
    });
  }

  void rejectFriendRequest(String id, String notifId) async {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(id)
        .collection('notifications')
        .doc(notifId)
        .delete();
  }

  void acceptFriendRequest(String id, String avatarName) async {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(id)
        .collection('notifications')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      'read': false,
      'type': FettleNotification.returnStringFromNotificationType(
          NotificationType.FettleTeam),
      'title': avatarName + " has accepted your friend request!",
      'subtitle': "This could be the start of something special.",
      'body': json.encode({'peerId': auth.userId}),
      'action': 0,
    });
    FirebaseFirestore.instance.collection('avatars').doc(id).update({
      'friendIds': FieldValue.arrayUnion([auth.userId])
    });
    FirebaseFirestore.instance.collection('avatars').doc(auth.userId).update({
      'friendIds': FieldValue.arrayUnion([id])
    });
    String groupChatId;
    if (auth.userId.compareTo(id) == -1) {
      groupChatId = auth.userId + '-' + id;
    } else {
      groupChatId = id + '-' + auth.userId;
    }
    FirebaseFirestore.instance.collection("chatlog").doc(groupChatId).set({
      'lastSentAt': DateTime.now().millisecondsSinceEpoch,
      'cats': [auth.userId, id]
    }, SetOptions(merge: true));
  }

  Future fetchYourself() async {
    try {
      DocumentSnapshot avatarDocument = await FirebaseFirestore.instance
          .collection('avatars')
          .doc(auth.userId)
          .get();
      Cat pengYou = Cat(
          country: avatarDocument.data()['country'] ?? 'Singapore',
          id: avatarDocument.id,
          name: avatarDocument.data()['name'],
          pushToken: avatarDocument.data()['pushToken'],
          past7DaysOfSteps: avatarDocument
              .data()['past7Days']
              .toList()
              .map((day) {
                return ActiveDay(
                    date: DateTime.fromMillisecondsSinceEpoch(day['timeStamp']),
                    stepsTracked: day['stepsTracked']);
              })
              .toList()
              .cast<ActiveDay>(),
          equippedItemId: avatarDocument.data()['equippedItemId'] ?? 0);
      return pengYou;
    } catch (e) {
      print(e);
    }
  }

  Future fetchFriends(List<String> friendIds) async {
    if (friendIds == null || friendIds.length == 0) {
      friendAvatars.clear();
      return;
    }
    ;
    try {
      QuerySnapshot friendQueries = await FirebaseFirestore.instance
          .collection('avatars')
          .where(FieldPath.documentId, whereIn: friendIds)
          .get();
      DocumentSnapshot avatarDocument = await FirebaseFirestore.instance
          .collection('avatars')
          .doc(auth.userId)
          .get();
      List<QueryDocumentSnapshot> friendDocuments = friendQueries.docs;
      friendAvatars = friendDocuments.map((friendDocument) {
        Cat pengYou = Cat(
            country: friendDocument.data()['country'] ?? 'Singapore',
            id: friendDocument.id,
            name: friendDocument.data()['name'],
            pushToken: friendDocument.data()['pushToken'],
            past7DaysOfSteps: friendDocument
                .data()['past7Days']
                .toList()
                .map((day) {
                  return ActiveDay(
                      date:
                          DateTime.fromMillisecondsSinceEpoch(day['timeStamp']),
                      stepsTracked: day['stepsTracked']);
                })
                .toList()
                .cast<ActiveDay>(),
            equippedItemId: friendDocument.data()['equippedItemId'] ?? 0);
        if (pengYou.id == avatarDocument.id) {
          pengYou.id = "me";
          pengYou.name = pengYou.name + " (you)";
        }
        return pengYou;
      }).toList();
      return;
    } catch (e) {
      print(e);
    }
  }

  Future fetchWorkoutBuddies(List<String> friendIds) async {
    if (friendIds == null || friendIds.length == 0) {
      workoutBuddyAvatars.clear();
      return;
    }
    try {
      QuerySnapshot friendQueries = await FirebaseFirestore.instance
          .collection('avatars')
          .where(FieldPath.documentId, whereIn: friendIds)
          .get();
      List<QueryDocumentSnapshot> friendDocuments = friendQueries.docs;

      workoutBuddyAvatars = friendDocuments.map((friendDocument) {
        Cat pengYou = Cat(
            country: friendDocument.data()['country'] ?? 'Singapore',
            id: friendDocument.id,
            name: friendDocument.data()['name'],
            pushToken: friendDocument.data()['pushToken'],
            past7DaysOfSteps: friendDocument
                .data()['past7Days']
                .toList()
                .map((day) {
                  return ActiveDay(
                      date:
                          DateTime.fromMillisecondsSinceEpoch(day['timeStamp']),
                      stepsTracked: day['stepsTracked']);
                })
                .toList()
                .cast<ActiveDay>(),
            equippedItemId: friendDocument.data()['equippedItemId'] ?? 0);
        return pengYou;
      }).toList();
      notifyListeners();
      return;
    } catch (e) {
      print(e);
    }
  }

  void update(AuthProvider auth) => this.auth = auth;
}
