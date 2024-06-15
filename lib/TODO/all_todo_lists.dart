import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/TODO/models/todo.dart';

import 'package:productivity_app/TODO/todo_list.dart';
import "package:productivity_app/TODO/widgets/grid_items/todo_grid_item.dart";
import "package:productivity_app/TODO/widgets/new_objects/new_todo.dart";

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/providers/repository_provider_TODO.dart';
import 'package:productivity_app/providers/user_provider.dart';

import 'package:uuid/uuid.dart';

var uuid = Uuid();
//Generate a v4 (random) id
//uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'

class AllToDoListsScreen extends ConsumerStatefulWidget {
  const AllToDoListsScreen({super.key});

  @override
  ConsumerState<AllToDoListsScreen> createState() {
    return _AllToDoListsScreenState();
  }
}

class _AllToDoListsScreenState extends ConsumerState<AllToDoListsScreen> {
  List<Todo> availableTodos = [];
  String? errorMessage;
  void _addToDo(AsyncValue<User?> user) async {
    final nToDo = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return newToDo();
      },
    );

    if (nToDo == null) {
      return;
    }

    ref.read(addTodoProvider(nToDo));
    Navigator.of(context).push<ToDoListScreen>(
      MaterialPageRoute(
        builder: (ctx) => ToDoListScreen(todo: nToDo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    final todoList = ref.watch(todosProvider);
    print(todoList);
    return Scaffold(
        appBar: AppBar(
          // title: Text('ALL TODO s'),
          actions: [
            IconButton(
                onPressed: () {
                  _addToDo(user);
                },
                icon: Icon(Icons.add)),
          ],
        ),
        body: todoList.when(
          data: (data) {
            return GridView(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              children: [
                for (final todoL in data)
                  ToDoGridItem(
                    todo: todoL,
                  )
              ],
            );
          },
          loading: () {
            return Center(child: CircularProgressIndicator());
          },
          error: (error, stackTrace) {
            return Center(child: Text('Error: $error'));
          },
        ));
  }
}
