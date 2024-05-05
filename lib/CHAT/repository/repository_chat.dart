import 'dart:ffi';

import 'package:productivity_app/CALENDAR/calendar.dart';
import 'package:productivity_app/TODO/models/priority.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:productivity_app/models/group.dart';
import 'package:productivity_app/models/message.dart';
import 'package:productivity_app/models/user.dart'; // in the firestore there is data NOT files

class FirebaseRepositoryCHAT {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! =========================================   CREATE GROUP   =========================================

  void createNewGroup(Group group) async {
    Message firstMessage = Message(
      senderId: group.senderId,
      text: group.lastMessage,
      type: MessageEnum.text,
      timeSent: group.timeSent,
      messageId: uuid.v4(),
      // repliedMessage: "",
      // repliedTo: "",
      //repliedMessageType: MessageEnum.text
    );
    group.membersUid.add(group.senderId);

    await _firestore
        .collection("groups")
        .doc('${group.groupId}')
        .set(group.toMap());

    await _firestore
        .collection("groups")
        .doc('${group.groupId}')
        .collection("Messages")
        .doc('${group.groupId}')
        .set(firstMessage.toMap());

    for (var user in group.membersUid) {
      List<String> groups = [];

      final snapshot = await _firestore
          .collection("users")
          .doc(user)
          .collection("SOCIAL")
          .doc('groups')
          .get();

      groups = List<String>.from(snapshot.data()!['inGroups']);

      groups.add(group.groupId);

      await FirebaseFirestore.instance
          .collection("users")
          .doc('${user}')
          .collection("SOCIAL")
          .doc("groups")
          .update({"inGroups": groups});
    }
  }

  //! =========================================   GET  GROUPS   =========================================
  Stream<List<Group>> getGroupsForUser(String user) {
    return _firestore.collection('groups').snapshots().map((event) {
      List<Group> groups = [];
      for (var document in event.docs) {
        var group = Group.fromMap(document.data());
        if (group.membersUid.contains(user)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  //! =========================================   SEND TEXT MESSAGE      =========================================

  void sendTextMessageToFirestore(
      String message, String user, String groupId) async {
    print("cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc");
    Message myMessage = Message(
      senderId: user,
      text: message,
      type: MessageEnum.text,
      timeSent: DateTime.now(),
      messageId: uuid.v4(),
    );
    print(
        "ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");

    await _firestore
        .collection("groups")
        .doc('${groupId}')
        .collection("Messages")
        .doc('${myMessage.messageId}')
        .set(myMessage.toMap());

    print(
        "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
  }

  //! =========================================   GET CHAT MESSAGES   =========================================

  Stream<List<Message>> getGroupChatStream(String groudId) {
    return _firestore
        .collection('groups')
        .doc(groudId)
        .collection('Messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }
}
