import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:productivity_app/TODO/models/task.dart";

import 'package:flutter/material.dart';
import 'package:productivity_app/TODO/task_detail.dart';
import 'package:productivity_app/TODO/todo_list.dart';
import 'package:productivity_app/TODO/widgets/dialog_delete_confirmation.dart';
import 'package:productivity_app/providers/repository_provider.dart';

class TaskGridItem extends ConsumerWidget {
  const TaskGridItem({
    super.key,
    required this.task,
    required this.todoId,
  });

  final MyTask task;
  final String todoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push<TaskDetail>(
          MaterialPageRoute(
            builder: (ctx) => TaskDetail(
              task: task,
              todoId: todoId,
            ),
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
                    ref.read(deleteTaskProvider([
                      todoId,
                      task.id,
                    ]));
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
        ),
        child: Text(
          task.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
    );
  }
}
