import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'auth.dart';
import '../models/notification.dart';

class NotificationsProvider with ChangeNotifier {
  AuthProvider auth;
  List<FettleNotification> notifications = [];

  Future<bool> fetchNotifications() async {
    try {
      QuerySnapshot queriedNotifications = await FirebaseFirestore.instance
          .collection('notifications')
          .doc(auth.userId)
          .collection('notifications')
          .limit(20)
          .get();
      notifications = queriedNotifications.docs.map((notification) {
        FettleNotification pengYou = FettleNotification(
            id: notification.id,
            read: notification.data()['read'] ?? false,
            type: FettleNotification.returnNotificationTypeFromFirebase(
                    notification.data()['type']) ??
                NotificationType.FriendRequest,
            title: notification.data()['title'] ?? 'Title',
            subtitle: notification.data()['subtitle'] ?? 'Subtitle',
            body: json.decode(notification.data()['body']) ?? {},
            action: notification.data()['action'] ?? 0);
        return pengYou;
      }).toList();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // READ NOTIFICATION
  void readNotification(String id) {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(auth.userId)
        .collection('notifications')
        .doc(id)
        .update({'read': true});
  }

  void interactWithNotification(String id, int action) {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(auth.userId)
        .collection('notifications')
        .doc(id)
        .update({'action': action});
  }

  void deleteNotification(String id) {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(auth.userId)
        .collection('notifications')
        .doc(id)
        .delete();
  }

  void update(AuthProvider auth) => this.auth = auth;
}
