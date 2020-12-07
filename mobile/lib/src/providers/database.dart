import 'package:cloud_firestore/cloud_firestore.dart';

// hi
class DatabaseMethods {
  getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection('avatars')
        .where("name", isEqualTo: username)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }
}
