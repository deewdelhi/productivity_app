import 'package:flutter/material.dart';
import 'package:productivity_app/TODO/models/priority.dart';
import 'package:productivity_app/TODO/models/task.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart'; // for dataTime formater
import 'package:numberpicker/numberpicker.dart';

var uuid = Uuid();
//Generate a v4 (random) id
//uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'

class NewTask extends StatefulWidget {
  NewTask({super.key, this.additionalDetails});

  bool? additionalDetails = false;

  @override
  State<StatefulWidget> createState() {
    return _NewTaskState();
  }
}

class _NewTaskState extends State<NewTask> {
  //extended view variables
  final _formKey = GlobalKey<FormState>();
  var _enteredTitle;
  var _enteredDescription;
  var _enteredPriority = Priorities.low;
  var _enteredAproxTimeToComplete = 0;
  var _enteredDeadline;
  // user points??

  void _submit() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final newTask = MyTask(
        id: uuid.v4(),
        title: _enteredTitle,
        description: _enteredDescription,
        priority: _enteredPriority,
        aproxTimeToComplete: _enteredAproxTimeToComplete,
        deadline: _enteredDeadline,
        isCompleted: false);

    Navigator.of(context).pop(newTask);
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
        title: Text('New Task'),
      ),
      body: SingleChildScrollView(
        // make page scrollable when keyboard appears
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                // ? can i use the initialValue for the update field

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'You must provide a title for your task';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredTitle = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                onSaved: (value) {
                  if (value != null) {
                    _enteredDescription = value;
                  }
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<Priorities>(
                value: _enteredPriority,
                items: Priorities.values.map((priority) {
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
                onChanged: (value) {
                  setState(() {
                    _enteredPriority = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text('Minutes to complete:'),
                        NumberPicker(
                          value: _enteredAproxTimeToComplete,
                          minValue: 0,
                          maxValue: 100,
                          onChanged: (value) => setState(
                              () => _enteredAproxTimeToComplete = value),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _enteredDeadline == null
                        ? 'Deadline: No date selected'
                        //: _enteredDeadline,
                        : 'Deadline: ${DateFormat('EEEE, d.MM.yyyy').format(_enteredDeadline)}',
                  ),
                  IconButton(
                    onPressed: _presentDatePicker,
                    icon: const Icon(
                      Icons.calendar_month,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: Text('Create'),
                      onPressed: () {
                        _submit();
                      },
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
