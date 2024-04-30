import 'package:productivity_app/TODO/models/priority.dart';

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
