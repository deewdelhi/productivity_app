import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:productivity_app/TODO/models/todo.dart";

import 'package:flutter/material.dart';
import 'package:productivity_app/TODO/todo_list.dart';
import 'package:productivity_app/TODO/widgets/dialog_delete_confirmation.dart';
import 'package:productivity_app/providers/repository_provider.dart';

class ToDoGridItem extends ConsumerWidget {
  const ToDoGridItem({
    super.key,
    required this.todo,
  });

  final Todo todo;

  // we ll seea bout the function
  // final void Function() onSelectCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black, // Border color
            width: 1.0, // Border width
          ),
          borderRadius: BorderRadius.circular(8.0), // Border radius
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push<ToDoListScreen>(
              MaterialPageRoute(
                builder: (ctx) => ToDoListScreen(todo: todo),
              ),
            );
          },
          onLongPress: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  String confirmationMessage =
                      " Are you sure you want to delete this TODO? It will also delete all the tasks inside";
                  return DeleteConfirmationDialog(
                      onConfirm: () {
                        ref.read(deleteCollectionProvider(todo.id));
                      },
                      message: confirmationMessage);
                });
          },
          splashColor: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              //gradient: LinearGradient(
              // colors: [
              //   category.color.withOpacity(0.55),
              //   category.color.withOpacity(0.9),
              // ],
              //begin: Alignment.topLeft,
              // end: Alignment.bottomRight,
              // ),
            ),
            child: Text(
              todo.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ),
        ));
  }
}
