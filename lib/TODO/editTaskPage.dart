import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:productivity_app/TODO/models/priority.dart';
import 'package:productivity_app/TODO/models/task.dart';

class EditTaskPage extends StatefulWidget {
  final MyTask task;

  EditTaskPage({required this.task});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String? _description;
  Priorities? _priority;
  int? _userPoints;
  int? _enteredAproxTimeToComplete;
  DateTime? _enteredDeadline;

  @override
  void initState() {
    super.initState();
    _title = widget.task.title;
    _description = widget.task.description;
    _priority = widget.task.priority;

    _enteredAproxTimeToComplete = widget.task.aproxTimeToComplete;
    _enteredDeadline = widget.task.deadline;
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      MyTask updatedTask = MyTask(
        id: widget.task.id,
        title: _title,
        description: _description,
        priority: _priority,
        aproxTimeToComplete: _enteredAproxTimeToComplete,
        deadline: _enteredDeadline,
      );

      Navigator.pop(context, updatedTask);
    }
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setState(() {
      _enteredDeadline = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensure the Scaffold adjusts to the keyboard
      appBar: AppBar(
        title: Text('Edit Task'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value;
                },
              ),
              DropdownButtonFormField<Priorities>(
                value: _priority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: Priorities.values.map((Priorities priority) {
                  return DropdownMenuItem<Priorities>(
                    value: priority,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.error, color: priorityMap[priority]!.color),
                        SizedBox(width: 10),
                        Text(priorityMap[priority]!.title),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (Priorities? newValue) {
                  setState(() {
                    _priority = newValue;
                  });
                },
                onSaved: (value) {
                  _priority = value;
                },
              ),
              SizedBox(height: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                            'Approximate Time to Complete: ${widget.task.aproxTimeToComplete} minutes',
                          ),
                          NumberPicker(
                            value: _enteredAproxTimeToComplete ?? 0,
                            minValue: 0,
                            maxValue: 100,
                            onChanged: (value) => setState(
                                () => _enteredAproxTimeToComplete = value),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _enteredDeadline == null
                          ? 'No date selected'
                          : 'Deadline: ${DateFormat('EEEE, d.MM.yyyy').format(widget.task.deadline!)}',
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(
                        Icons.calendar_month,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
