import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/TODO/editTaskPage.dart';
import 'package:productivity_app/TODO/models/priority.dart';
import 'package:productivity_app/TODO/models/task.dart';
import 'package:productivity_app/TODO/widgets/dialog_delete_confirmation.dart';
import 'package:productivity_app/providers/repository_provider_TODO.dart';

class TaskDetailPage extends ConsumerWidget {
  MyTask task;
  String todoId;

  TaskDetailPage({required this.task, required this.todoId});

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('EEEE, d.MM.yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Priority? taskPriority =
        task.priority != null ? priorityMap[task.priority!] : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: taskPriority?.color ?? Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  task.title,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    var updatedTask = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => EditTaskPage(
                          task: task,
                        ),
                      ),
                    );

                    Map<String, MyTask> data = {
                      todoId: updatedTask,
                    };
                    ref.read(updateTaskProvider(data));
                    Navigator.of(context).pop();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print(
                        " de ce dracu nu vrei sa mai stergi hestii cand acum 2 min  nu ai avut nici pe drcC");
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
                                Navigator.of(context).pop();
                              },
                              message: confirmationMessage);
                        });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (taskPriority != null) ...[
              Row(
                children: [
                  Text(
                    'Priority: ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: taskPriority.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      taskPriority.title,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
            if (task.description != null) ...[
              Text(
                'Description:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(task.description!),
              SizedBox(height: 16),
            ],
            if (task.aproxTimeToComplete != null) ...[
              Text(
                'Approximate Time to Complete:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('${task.aproxTimeToComplete} minutes'),
              SizedBox(height: 16),
            ],
            if (task.deadline != null) ...[
              Text(
                'Deadline:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(_formatDate(task.deadline!)),
              SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
