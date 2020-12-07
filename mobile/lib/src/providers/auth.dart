import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  bool initOnline = false;
  bool tempLockDisable = false;
  bool onboarded = false;

  bool get isLoggedIn => _fAuth.currentUser != null;
  String get userId => _fAuth.currentUser.uid;

  Future<bool> smsLogin(User user) async {
    try {
      firebaseMessaging.getToken().then((token) async {
        FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'pushToken': token,
        });
      }).catchError((err) {
        print(err);
      });
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return true;
  }

  Future<bool> smsLogout() async {
    await _fAuth.signOut();
    notifyListeners();
    return true;
  }
}
