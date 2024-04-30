import 'package:productivity_app/TODO/models/priority.dart';
import 'package:productivity_app/TODO/models/task.dart';
import 'package:productivity_app/TODO/models/todo.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart'; // in the firestore there is data NOT files

class FirebaseRepositoryTODO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //!  ==============================   GET DATA   ==============================

  Stream<List<Todo>> fetchDataStreamFromFirebase(AsyncValue<User?> user) {
    final _firestore = FirebaseFirestore.instance;

    return _firestore
        .collection("users")
        .doc(user.value!.uid)
        .collection("TODOS")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Todo(
                  id: doc.id,
                  title: doc.data()["title"],
                  // You can add other properties here
                ))
            .toList());
  }

  Stream<List<MyTask>> getTasksForTodoFirestore(
    AsyncValue<User?> user,
    String todoId,
  ) {
    final _firestore = FirebaseFirestore.instance;

    return _firestore
        .collection("users")
        .doc(user.value!.uid)
        .collection("TODOS")
        .doc(todoId)
        .collection("TASKS")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final id = doc.id;
              final title = doc.data()["title"];
              final description = doc.data()["description"];
              Priorities? priority;
              switch (doc.data()["priority"]) {
                case "low":
                  priority = Priorities.low;
                  break;
                case "medium":
                  priority = Priorities.medium;
                  break;
                case "high":
                  priority = Priorities.high;
                  break;
              }
              DateTime? deadline;
              if (doc.data()["deadline"] != null) {
                final timestamp = doc.data()["deadline"];
                deadline = timestamp.toDate();
              }

              final aproxTimeToComplete =
                  doc.data()["aproximateTimeToComplete"];
              final userPoints = doc.data()["userPoints"];

              return MyTask(
                id: id,
                title: title,
                description: description,
                priority: priority,
                aproxTimeToComplete: aproxTimeToComplete,
                deadline: deadline,
                userPoints: userPoints,
              );
            }).toList());
  }

  //!  ==============================   ADD DATA   ==============================

  void addTodoToFirebase(AsyncValue<User?> user, Todo todo) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc('${user.value!.uid}')
        .collection("TODOS")
        .doc("${todo.id}")
        .set({'title': '${todo.title}'});
  }

  void addTaskToFirebase(
      AsyncValue<User?> user, Map<String, MyTask> dataTask) async {
    var priority;

    String todoId = dataTask.keys.first;
    MyTask task = dataTask[todoId]!;

    switch (task.priority!) {
      case Priorities.low:
        {
          priority = "low";
        }
        break;

      case Priorities.medium:
        {
          priority = "medium";
        }
        break;
      case Priorities.high:
        {
          priority = "high";
        }
        break;
    }

    var data = {
      'title': task.title,
      'description': task.description,
      'priority': priority,
      'aproximateTimeToComplete': task.aproxTimeToComplete,
      'deadline': task.deadline,
      'userPoints': task.userPoints
    };

    await FirebaseFirestore.instance
        .collection("users")
        .doc('${user.value!.uid}')
        .collection("TODOS")
        .doc("${todoId}")
        .collection("TASKS")
        .doc(task.id)
        .set(data);
  }

  //!  ==============================   DELETE DATA   ==============================

//* this is to delete a todo with all the tasks inside it

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

  //* this is to delete a task inside the todo
  Future<void> deleteTask(AsyncValue<User?> user, List<String> ids) async {
    await _firestore
        .collection("users")
        .doc(user.value!.uid)
        .collection("TODOS")
        .doc(ids[0])
        .collection("TASKS")
        .doc("${ids[1]}")
        .delete();
  }
}
