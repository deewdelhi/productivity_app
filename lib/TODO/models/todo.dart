import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/TODO/models/task.dart';

class Todo {
  Todo({required this.id, required this.title, List? tasks});

  String id;
  final String title;
  final List<MyTask> tasks = [];

  // * these are not used yet, wanna make it work normally
  factory Todo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Todo(
      id: data?['id'],
      title: data?['title'],
      tasks: data?['tasks'] is Iterable ? List.from(data?['tasks']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (title != null) "title": title,
      if (tasks != null) "tasks": tasks,
      // TODO: check these
    };
  }
}
