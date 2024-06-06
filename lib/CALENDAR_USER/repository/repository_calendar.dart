import 'dart:collection';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/CALENDAR_USER/models/myEvent.dart';
import 'package:time_planner/time_planner.dart';

class FirebaseRepositoryCALENDAR {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//! =========================================   ADD EVENT TO FIRESTORE      =========================================

  void addEventToFirestore(AsyncValue<User?> user, MyEvent newEvent) async {
    // Check if the user is valid
    if (user.value == null) {
      print("Error: User is null");
      return;
    }

    // Ensure newEvent fields are properly populated
    if (newEvent.id == null || newEvent.dateTime == null) {
      print("Error: newEvent.id or newEvent.dateTime is null");
      return;
    }

    String dateIdFormat = DateFormat('dd_MM_yyyy').format(newEvent.dateTime);

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.value!.uid)
          .collection("USER_CALENDAR")
          .doc(dateIdFormat)
          .set({'title': "ce dracu aiaiaiaiaiai"});

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.value!.uid)
          .collection("USER_CALENDAR")
          .doc(dateIdFormat)
          .collection("EVENTS")
          .doc(newEvent.id)
          .set({
        'id': newEvent.id,
        'durationMinutes': newEvent.minutesDuration.toString(),
        'color': newEvent.color.toString(),
        'description': newEvent.description.toString(),
        'title': newEvent.title.toString(),
        'datetime': newEvent.dateTime.toString()
      });

      print("Event successfully added to Firestore");
    } catch (e) {
      print("Error adding event to Firestore: $e");
    }
  }

  //! =========================================   GET EVENTS FROM  FIRESTORE      =========================================

  Stream<List<String>> getDatesWithEventsFirestore(String user) {
    if (user == null) {
      // Print an error message if user is null
      print("User is null");
      return Stream.value([]);
    }

    print("Fetching documents for user: ${user}");

    return _firestore
        .collection('users')
        .doc(user)
        .collection("USER_CALENDAR")
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        // Print a message if no documents are found
        print("No documents found in USER_CALENDAR collection");
        return [];
      }

      // Extract and print document IDs
      List<String> docIds = snapshot.docs.map((doc) => doc.id).toList();
      print("Retrieved document IDs: $docIds");

      return docIds;
    });
  }

  Stream<List<MyEvent>> getEventsForDateFromFirestore(
      String user, String date) {
    return _firestore
        .collection("users")
        .doc(user)
        .collection("USER_CALENDAR")
        .doc(date)
        .collection("EVENTS")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              String color = doc.data()["color"];
              String hexColor = color.substring(
                  color.indexOf('0x') + 2, color.lastIndexOf(')'));

              Color newColor =
                  Color(int.parse(hexColor.replaceFirst(")", ""), radix: 16));
              String id = doc.data()["id"];
              String title = doc.data()["title"];
              String description = doc.data()["description"];
              int minutesDuration = int.parse(doc.data()["durationMinutes"]);
              DateTime dateTime = DateTime.parse(doc.data()["datetime"]);

              return MyEvent(
                  id: id,
                  userId: user,
                  description: description,
                  title: title,
                  minutesDuration: minutesDuration,
                  dateTime: dateTime,
                  color: newColor);
            }).toList());
  }

  //! =========================================   REMOVE EVENT FROM  FIRESTORE      =========================================

  Future<void> deleteEvent(AsyncValue<User?> user, List<String> ids) async {
    // ids[0] - the date when the event is taken place
    // ids[1] - the id of the event you want to delete

    await _firestore
        .collection("users")
        .doc(user.value!.uid)
        .collection("USER_CALENDAR")
        .doc(ids[0])
        .collection("EVENTS")
        .doc("${ids[1]}")
        .delete();
  }

  //? =========================================   stuff for the shared calendar     =========================================
  //**
  // in the groups there are the members, use that to get the events for separate users
  // should add a color for each user in the group to see whose events are actaully in the calendar

  //
  // */

// Combining all streams into a single stream of events for a list of user IDs
}
