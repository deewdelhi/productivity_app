import 'package:productivity_app/TODO/models/task.dart';
import 'package:productivity_app/TODO/models/priority.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

var uuid = Uuid();
//Generate a v4 (random) id
//uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'

// List<Task> create_dummy_tasks() {
//   final List<Task> tasks = [];

//   for (int i = 0; i < 10; i++) {
//     tasks.add(Task(
//       id: uuid.v4(),
//       title: "Task ${i + 1}",
//       description: "Description for Task ${i + 1}",
//       priority: HighPriority,
//     ));
//   }

//   return tasks;
// }
