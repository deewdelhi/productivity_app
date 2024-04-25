import 'package:flutter/material.dart';
import 'package:productivity_app/TODO/models/priority.dart';
import 'package:productivity_app/TODO/models/todo.dart';

import 'package:productivity_app/TODO/widgets/grid_items/task_grid_item.dart';
import 'package:productivity_app/TODO/widgets/new_objects/new_task.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/providers/repository_provider.dart';
import 'package:productivity_app/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // in the firestore there is data NOT files
import 'package:firebase_storage/firebase_storage.dart'; // sending files to firebase, pat of the sdk
import 'dart:math';
import 'package:productivity_app/TODO/models/dummy_tasks.dart';
import 'package:productivity_app/TODO/models/task.dart';

class ToDoListScreen extends ConsumerStatefulWidget {
  ToDoListScreen({
    super.key,
    required this.todo,
  });

  Todo todo;

  @override
  ConsumerState<ToDoListScreen> createState() {
    return _ToDoListScreenState();
  }
}

class _ToDoListScreenState extends ConsumerState<ToDoListScreen> {
  void _addTask(AsyncValue<User?> user) async {
    var nTask = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => NewTask(),
      ),
    );

    print(nTask);
    Map<String, MyTask> data = {
      widget.todo.id: nTask,
    };
    ref.read(addTaskProvider(data));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    final taskList = ref.watch(tasksProvider(widget.todo.id));
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.todo.title}'),
          actions: [
            IconButton(
                onPressed: () {
                  _addTask(user);
                },
                icon: Icon(Icons.add)),
            IconButton(
                onPressed: () {
                  //_getTasksForTodoFirestore(user, widget.todo);
                },
                icon: Icon(Icons.get_app_sharp)),
          ],
        ),
        body: taskList.when(
          data: (data) {
            return Center(
                child: GridView(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              children: [
                for (final task in data)
                  TaskGridItem(
                    task: task,
                    todoId: widget.todo.id,
                  )
              ],
            ));
          },
          loading: () {
            // Data is still loading, show a loading indicator
            return Center(child: CircularProgressIndicator());
          },
          error: (error, stackTrace) {
            // An error occurred while fetching data, handle the error
            return Center(child: Text('Error: $error'));
          },
        ));
  }
}
