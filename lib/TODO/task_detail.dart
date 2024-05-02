import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/TODO/models/priority.dart';
import 'package:productivity_app/TODO/models/task.dart';
import 'package:productivity_app/providers/repository_provider_TODO.dart';

class TaskDetail extends ConsumerStatefulWidget {
  TaskDetail({super.key, required this.task, required this.todoId});

  MyTask task;
  String todoId;

  @override
  ConsumerState<TaskDetail> createState() {
    return _TaskDetailState();
  }
}

class _TaskDetailState extends ConsumerState<TaskDetail> {
  // Controllers for the text fields
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController aproxTimeController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  TextEditingController userPointsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize the text field controllers with initial values
    titleController.text = widget.task.title;
    descriptionController.text = widget.task.description ?? '';
    priorityController.text = priorityMap[widget.task.priority]?.title ?? '';
    aproxTimeController.text =
        widget.task.aproxTimeToComplete?.toString() ?? '';
    deadlineController.text = widget.task.deadline?.toString() ?? '';
    userPointsController.text = widget.task.userPoints?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
        actions: [
          IconButton(
            onPressed: () {
              // TODO add the logic for saving the new task
              // TODO: DO THE FUCKING UPDATEEEEEEEE
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.save),
          ),
          IconButton(
            onPressed: () {
              ref.read(deleteTaskProvider([widget.todoId, widget.task.id]));
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priorityController,
              decoration: InputDecoration(labelText: 'Priority'),
            ),
            TextField(
              controller: aproxTimeController,
              decoration:
                  InputDecoration(labelText: 'Approx. Time to Complete'),
            ),
            TextField(
              controller: deadlineController,
              decoration: InputDecoration(labelText: 'Deadline'),
            ),
            TextField(
              controller: userPointsController,
              decoration: InputDecoration(labelText: 'User Points'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the text field controllers
    titleController.dispose();
    descriptionController.dispose();
    priorityController.dispose();
    aproxTimeController.dispose();
    deadlineController.dispose();
    userPointsController.dispose();
    super.dispose();
  }
}
