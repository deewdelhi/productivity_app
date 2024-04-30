import 'package:productivity_app/TODO/models/priority.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:productivity_app/models/user.dart'; // in the firestore there is data NOT files

class FirebaseRepositorySOCIAL {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //!  ==============================   GET ALL  USERS  ==============================

  Stream<List<MyUser>> fetchAllUsersStreamFromFirebase() {
    return _firestore
        .collection("users")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MyUser(
                  id: doc.id,
                  email: doc.data()["email"],
                  firstNmae: doc.data()["username"],
                  lastName: doc.data()["username"],
                  pictureUrl: doc.data()["image_url"],
                ))
            .toList());
  }
  //!  ==============================   GET LISTS  ==============================

  Stream<List<String>> fetchSocialStreamFromFirebase(AsyncValue<User?> user) {
    return _firestore
        .collection("users")
        .doc(user.value!.uid)
        .collection("SOCIAL")
        .doc('manageFriends')
        .snapshots()
        .map((snapshot) => [
              ...(snapshot.data()?['friends'] ?? []),
              ...(snapshot.data()?['incoming_requests'] ?? []),
              ...(snapshot.data()?['sent_requests'] ?? []),
            ]);
  }

  //!  ==============================   SEND FRIEND REQUEST ( add to another user incoming add to your send)  ==============================

  //!  ==============================   DELETE REQUEST (accept or decline) ( remove from your incoming and remove from theyr sent)  ==============================
}
