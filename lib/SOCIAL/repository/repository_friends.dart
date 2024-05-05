import 'dart:ffi';

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
                  firstNmae: doc.data()["firstName"],
                  lastName: doc.data()["lastName"],
                  username: doc.data()["username"],
                  pictureUrl: doc.data()["image_url"],
                ))
            .toList());
  }
  //!  ==============================   GET LISTS  ==============================

  Future<List<List<String>>> fetchSocialStreamFromFirebase(
      AsyncValue<User?> user) async {
    List<List<String>> resultList = [];

    final snapshot = await _firestore
        .collection("users")
        .doc(user.value!.uid)
        .collection("SOCIAL")
        .doc('manageFriends')
        .get();

    // Add 'friends' list
    resultList.add(List<String>.from(snapshot.data()!['friends']));

    // Add 'incoming_requests' list
    resultList.add(List<String>.from(snapshot.data()!['incoming_requests']));

    // Add 'sent_requests' list
    resultList.add(List<String>.from(snapshot.data()!['sent_requests']));

    return resultList;
  }
  //!  ==============================   SEND FRIEND REQUEST ( add to another user incoming add to your send)  ==============================

  void sendFriendRequestToFirestore(String from_user, String to_user) async {
    List<String> resultList = [];
    List<String> resultList2 = [];

    final snapshot = await _firestore
        .collection("users")
        .doc(to_user)
        .collection("SOCIAL")
        .doc('manageFriends')
        .get();

    resultList = List<String>.from(snapshot.data()!['incoming_requests']);

    resultList.add(from_user);

    await FirebaseFirestore.instance
        .collection("users")
        .doc('${to_user}')
        .collection("SOCIAL")
        .doc("manageFriends")
        .update({"incoming_requests": resultList});

    final snapshot2 = await _firestore
        .collection("users")
        .doc(from_user)
        .collection("SOCIAL")
        .doc('manageFriends')
        .get();

    resultList2 = List<String>.from(snapshot2.data()!['sent_requests']);
    resultList2.add(to_user);

    await FirebaseFirestore.instance
        .collection("users")
        .doc('${from_user}')
        .collection("SOCIAL")
        .doc("manageFriends")
        .update({"sent_requests": resultList2});
  }

  //!  ==============================   DELETE REQUEST (accept or decline) ( remove from your incoming and remove from theyr sent)  ==============================

  void addressFriendRequest(
      String user, String from_user, bool accept_request) async {
    // * : decline a friend request
    /*
      - remove from incoming_requats from user 
      - remove from sent_requats from from_user
      */

    // * : accept a friend request
    /*
      - remove from incoming_requats from user 
      - remove from sent_requats from from_user
      - add each other to friends 
      */

    List<String> incomingList_1 = [];
    List<String> friendsList_1 = [];

    List<String> sendList_2 = [];
    List<String> friendsList_2 = [];

    final snapshot1 = await _firestore
        .collection("users")
        .doc(user)
        .collection("SOCIAL")
        .doc('manageFriends')
        .get();

    final snapshot2 = await _firestore
        .collection("users")
        .doc(from_user)
        .collection("SOCIAL")
        .doc('manageFriends')
        .get();

    incomingList_1 = List<String>.from(snapshot1.data()!['incoming_requests']);
    friendsList_1 = List<String>.from(snapshot1.data()!['friends']);
    sendList_2 = List<String>.from(snapshot2.data()!['sent_requests']);
    friendsList_2 = List<String>.from(snapshot2.data()!['friends']);

    incomingList_1.remove(from_user);
    sendList_2.remove(user);

    await FirebaseFirestore.instance
        .collection("users")
        .doc('${user}')
        .collection("SOCIAL")
        .doc("manageFriends")
        .update({"incoming_requests": incomingList_1});

    await FirebaseFirestore.instance
        .collection("users")
        .doc('${from_user}')
        .collection("SOCIAL")
        .doc("manageFriends")
        .update({"sent_requests": sendList_2});

    if (accept_request == true) {
      friendsList_1.add(from_user);
      friendsList_2.add(user);

      await FirebaseFirestore.instance
          .collection("users")
          .doc('${user}')
          .collection("SOCIAL")
          .doc("manageFriends")
          .update({"friends": friendsList_1});

      await FirebaseFirestore.instance
          .collection("users")
          .doc('${from_user}')
          .collection("SOCIAL")
          .doc("manageFriends")
          .update({"friends": friendsList_2});
    }
  }

  //!  ==============================    REMOVE FRIEND  ==============================

  void removeFriendFirestore(String user, String exFriend) async {
    List<String> friendsList_1 = [];

    List<String> friendsList_2 = [];

    final snapshot1 = await _firestore
        .collection("users")
        .doc(user)
        .collection("SOCIAL")
        .doc('manageFriends')
        .get();

    final snapshot2 = await _firestore
        .collection("users")
        .doc(exFriend)
        .collection("SOCIAL")
        .doc('manageFriends')
        .get();

    friendsList_1 = List<String>.from(snapshot1.data()!['friends']);
    friendsList_2 = List<String>.from(snapshot2.data()!['friends']);

    friendsList_1.remove(exFriend);
    friendsList_2.remove(user);

    await FirebaseFirestore.instance
        .collection("users")
        .doc('${user}')
        .collection("SOCIAL")
        .doc("manageFriends")
        .update({"friends": friendsList_1});

    await FirebaseFirestore.instance
        .collection("users")
        .doc('${exFriend}')
        .collection("SOCIAL")
        .doc("manageFriends")
        .update({"friends": friendsList_2});
  }

  //!  ==============================    UNDO FRIEND REQUEST  ==============================

  void undoFriendRequestFirestore(String user, String exFriend) async {
    List<String> sentRequestsList_1 = [];

    List<String> inocmingList_2 = [];

    final snapshot1 = await _firestore
        .collection("users")
        .doc(user)
        .collection("SOCIAL")
        .doc('manageFriends')
        .get();

    final snapshot2 = await _firestore
        .collection("users")
        .doc(exFriend)
        .collection("SOCIAL")
        .doc('manageFriends')
        .get();

    sentRequestsList_1 = List<String>.from(snapshot1.data()!['sent_requests']);
    inocmingList_2 = List<String>.from(snapshot2.data()!['incoming_requests']);

    sentRequestsList_1.remove(exFriend);
    inocmingList_2.remove(user);

    await FirebaseFirestore.instance
        .collection("users")
        .doc('${user}')
        .collection("SOCIAL")
        .doc("manageFriends")
        .update({"sent_requests": sentRequestsList_1});

    await FirebaseFirestore.instance
        .collection("users")
        .doc('${exFriend}')
        .collection("SOCIAL")
        .doc("manageFriends")
        .update({"incoming_requests": inocmingList_2});
  }
}
