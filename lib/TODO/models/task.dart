import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:productivity_app/TODO/models/priority.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyTask {
  MyTask(
      {required this.id,
      required this.title,
      this.description,
      this.priority,
      this.aproxTimeToComplete,
      this.deadline,
      userPoints});

  final String id;
  final String title;
  String? description;
  Priorities? priority;
  int? aproxTimeToComplete;
  DateTime? deadline;
  int? userPoints;
}
