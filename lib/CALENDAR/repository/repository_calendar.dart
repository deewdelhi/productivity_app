import 'dart:collection';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/CALENDAR/models/myEvent.dart';
import 'package:time_planner/time_planner.dart';

class FirebaseRepositoryCALENDAR {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//! =========================================   ADD EVENT TO FIRESTORE      =========================================

  void addEventToFirestore(AsyncValue<User?> user, MyEvent newEvent) async {
    String dateIdFormat = DateFormat('dd_MM_yyyy').format(newEvent.dateTime);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.value!.uid)
        .collection("CALENDAR")
        .doc("${dateIdFormat}")
        .collection("EVENTS")
        .doc("${newEvent.id}")
        .set({
      'id': newEvent.id,
      'durationMinutes': newEvent.minutesDuration.toString(),
      'color': newEvent.color.toString(),
      'description': newEvent.description.toString(),
      'title': newEvent.title.toString(),
      'datetime': newEvent.dateTime.toString()
    });
  }

  //! =========================================   GET EVENTS FROM  FIRESTORE      =========================================

  Stream<List<String>> getDatesWithEventsFirestore(AsyncValue<User?> user) {
    return _firestore
        .collection("users")
        .doc(user.value!.uid)
        .collection("CALENDAR")
        .snapshots()
        .map((QuerySnapshot snapshot) =>
            snapshot.docs.map((QueryDocumentSnapshot doc) => doc.id).toList());
  }

  Stream<List<MyEvent>> getEventsForDateFromFirestore(
      AsyncValue<User?> user, String date) {
    return _firestore
        .collection("users")
        .doc(user.value!.uid)
        .collection("CALENDAR")
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
              String description = doc.data()["descripiton"];
              int minutesDuration = int.parse(doc.data()["durationMinutes"]);
              DateTime dateTime = DateTime.parse(doc.data()["datetime"]);
              return MyEvent(
                  id: id,
                  description: description,
                  title: title,
                  minutesDuration: minutesDuration,
                  dateTime: dateTime,
                  color: newColor);
            }).toList());
  }
}




  // Stream<Map<String, List<MyEvent>>> getCalendarEventsStream(
  //     AsyncValue<User?> user) {
  //   return _firestore
  //       .collection("users")
  //       .doc(user.value!.uid)
  //       .collection("CALENDAR")
  //       .snapshots()
  //       .map((QuerySnapshot snapshot) {
  //     Map<String, List<MyEvent>> eventsMap = {};

  //     snapshot.docs.forEach((QueryDocumentSnapshot dateDoc) {
  //       List<String> dateParts =
  //           dateDoc.id.split('_'); // Split the string into day, month, and year

  //       int day = int.parse(dateParts[0]); // Extract day
  //       int month = int.parse(dateParts[1]); // Extract month
  //       int year = int.parse(dateParts[2]); // Extract year

  //       DateTime dateTime = DateTime(year, month, day);

  //       final events = dateDoc.reference.collection('EVENTS').get().then(
  //           (eventSnapshot) => eventSnapshot.docs
  //               .map((eventDoc) => MyEvent.fromMap(eventDoc.data()))
  //               .toList());

  //       events.then((value) =>
  //           eventsMap[DateFormat('dd/MM/yyyy').format(dateTime)] = value);
  //     });
  //     print(
  //         "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
  //     print(eventsMap.keys);
  //     print(eventsMap[eventsMap.keys.first]);

  //     return eventsMap;
  //   });
  // }