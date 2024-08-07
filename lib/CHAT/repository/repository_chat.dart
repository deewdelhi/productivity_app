import 'dart:ffi';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:productivity_app/CALENDAR_USER/calendar.dart';
import 'package:productivity_app/TODO/models/priority.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:productivity_app/models/group.dart';
import 'package:productivity_app/models/message.dart';
import 'package:productivity_app/models/user.dart'; // in the firestore there is data NOT files

import 'package:uuid/uuid.dart';

var uuid = Uuid();

class FirebaseRepositoryCHAT {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! =========================================   CREATE GROUP   =========================================

  void createNewGroup(Group group) async {
    // TODO: move the logic for sending the group picture to firestore here from the new_chatScreen.dart
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

  //! =========================================  UPDATE GROUP MEMBERS  =========================================

  void updateGroupMembersFirestore(
      String groupId, List<String> newMembers) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .update({"membersUid": newMembers});
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

  Stream<List<String>> getUsersForGroup(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .map((snapshot) {
      // Ensure the document exists and the field is present
      if (snapshot.exists && snapshot.data() != null) {
        return List<String>.from(snapshot.data()!["membersUid"]);
      } else {
        // Return an empty list if the document doesn't exist or the field is not present
        return [];
      }
    });
  }

  //! =========================================   SEND TEXT MESSAGE      =========================================

  void sendTextMessageToFirestore(
      // TODO: update the group data so you can see the last message
      String message,
      String user,
      String groupId) async {
    Message myMessage = Message(
      senderId: user,
      text: message,
      type: MessageEnum.text,
      timeSent: DateTime.now(),
      messageId: uuid.v4(),
    );

    await _firestore
        .collection("groups")
        .doc('${groupId}')
        .collection("Messages")
        .doc('${myMessage.messageId}')
        .set(myMessage.toMap());
  }

  //! =========================================   SEND FILE MESSAGE      =========================================

  void sendFileMessageToFirestore(
      String messageType, File message, String user, String groupId) async {
    String MessageId = uuid.v4();

    String contactMsg;
    // TODO: update the group data so you can see the last message
    String lastForFirebase = '';

    switch (messageType) {
      case "image":
        contactMsg = '📷 Photo';
        lastForFirebase = '${MessageId}.jpg';
        break;
      case "video":
        contactMsg = '📸 Video';
        break;
      case "audio":
        contactMsg = '🎵 Audio';
        break;
      case "gif":
        contactMsg = 'GIF';
        break;
      default:
        contactMsg = 'GIF';
    }

    final storageRef = FirebaseStorage.instance
        .ref() // just a reference to our firebase storage so that we can modify it
        .child('group_chats_media')
        .child('${groupId}')
        .child('${messageType}_content') // to create a new path in the folder
        .child(lastForFirebase);

    await storageRef.putFile(message!); // to put the file to that path
    String message_url = await storageRef
        .getDownloadURL(); // we need this so that later we can actually use and display that image and that s why we put it later in image_url

    Message myMessage = Message(
        senderId: user,
        text: message_url,
        type: messageType.toEnum(),
        timeSent: DateTime.now(),
        messageId: MessageId);

    await _firestore
        .collection("groups")
        .doc('${groupId}')
        .collection("Messages")
        .doc('${myMessage.messageId}')
        .set(myMessage.toMap());
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

  //! =========================================   SEND GIF MESSAGE      =========================================

  void sendGifMessageToFirestore(
      // TODO: update the group data so you can see the last message
      String gifUrl,
      String user,
      String groupId) async {
    Message myMessage = Message(
      senderId: user,
      text: gifUrl,
      type: MessageEnum.gif,
      timeSent: DateTime.now(),
      messageId: uuid.v4(),
    );

    await _firestore
        .collection("groups")
        .doc('${groupId}')
        .collection("Messages")
        .doc('${myMessage.messageId}')
        .set(myMessage.toMap());
  }

  //! =========================================   DELETE GROUP       =========================================

  Future<void> deleteCollection(AsyncValue<User?> user, String todoId) async {
    CollectionReference subcollectionRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.value!.uid)
        .collection("TODOS")
        .doc(todoId)
        .collection("TASKS");

    QuerySnapshot querySnapshot = await subcollectionRef.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await documentSnapshot.reference.delete();
    }
    await _firestore
        .collection("users")
        .doc("${user.value!.uid}")
        .collection("TODOS")
        .doc("${todoId}")
        .delete();
  }

  Future<void> deleteMessagesForGroup(String groupId) async {
    CollectionReference subcollectionRef = FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("Messages");

    QuerySnapshot querySnapshot = await subcollectionRef.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await documentSnapshot.reference.delete();
    }
  }

  Future<void> deleteEventsForGroup(String groupId) async {
    CollectionReference subcollectionRef = FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("GroupEvents");

    QuerySnapshot querySnapshot = await subcollectionRef.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await documentSnapshot.reference.delete();
    }
  }

  Future<void> deleteGroup(String groupId) async {
    await _firestore.collection("groups").doc(groupId).delete();
  }

  Future<void> deleteEntireGroup(String groupId) async {
    await deleteMessagesForGroup(groupId);
    await deleteEventsForGroup(groupId);
    await deleteGroup(groupId);
  }
}
