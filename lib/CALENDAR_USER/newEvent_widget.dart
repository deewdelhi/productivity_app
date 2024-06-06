import 'dart:math';

import 'package:flutter/material.dart';
import 'package:productivity_app/CALENDAR_USER/models/myEvent.dart';
import 'package:time_planner/time_planner.dart';

import 'package:uuid/uuid.dart';

var uuid = Uuid();

class newEventWidget extends StatefulWidget {
  Function onSubmitNewEvent;
  bool isWithDayPicker;
  String userId;

  newEventWidget(
      {required this.isWithDayPicker,
      required this.onSubmitNewEvent,
      required this.userId,
      super.key});

  @override
  State<newEventWidget> createState() {
    return _newEventWidgetState();
  }
}

class _newEventWidgetState extends State<newEventWidget> {
  TextEditingController _eventTitleController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();
//  TextEditingController _eventHourController = TextEditingController();
  DateTime? dateForEvent;
  TimeOfDay? timeForEvent;
  TimeOfDay? timeForEventToEnd;

  void _presentHourPicker(bool isBeginEvent) async {
    FocusScope.of(context).unfocus();
    final initialTime = TimeOfDay(hour: 0, minute: 0);
    final pickedTime =
        await showTimePicker(context: context, initialTime: initialTime);

    if (isBeginEvent) {
      setState(() {
        timeForEvent = pickedTime;
      });
    } else {
      setState(() {
        timeForEventToEnd = pickedTime;
      });
    }
  }

  void _presentDatePicker() async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 2, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: lastDate,
    );
    setState(() {
      dateForEvent = pickedDate;
    });
  }

  bool isDateTimeValid(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (dateTime.isBefore(now)) {
      return false;
    } else {
      return true;
    }
  }

  bool areHoursValid(TimeOfDay time1, TimeOfDay time2) {
    bool isTime1Earlier = isEarlier(time1, time2);
    return isTime1Earlier;
  }

  String userInputValidator() {
    String inputProblems = "";
    bool isDateValid = isDateTimeValid(dateForEvent!);
    bool areHValid = areHoursValid(timeForEvent!, timeForEventToEnd!);
    bool isTitleValid;
    if (_eventTitleController.text.isEmpty) {
      isTitleValid = false;
    } else {
      isTitleValid = true;
    }

    if (isDateValid == false) {
      inputProblems = inputProblems + "- date not valid ";
    } else if (areHValid == false) {
      inputProblems = inputProblems + "- hours not valid ";
    } else if (isTitleValid == false) {
      inputProblems = inputProblems + "-title should not be empty";
    }
    if (inputProblems != "") return inputProblems;

    return "valid input";
  }

  void _onSubmitNewEvent() {
    List<Color?> colors = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.lime[600]
    ];

    FocusScope.of(context).unfocus();
    String statusInput = userInputValidator();
    if (statusInput != "valid input") {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      final snackBar = SnackBar(
        content: Text(statusInput),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    } else {
      int hour = timeForEvent!.hour;
      int minute = timeForEvent!.minute;

      DateTime updatedDateTime = DateTime(
        dateForEvent!.year,
        dateForEvent!.month,
        dateForEvent!.day,
        hour,
        minute,
      );

      MyEvent newEvent = MyEvent(
        id: uuid.v4(),
        userId: widget.userId,
        color: colors[Random().nextInt(colors.length)]!,
        title: _eventTitleController.text,
        minutesDuration:
            calculateDifferenceInMinutes(timeForEvent!, timeForEventToEnd!),
        dateTime: updatedDateTime,
        description: _eventDescriptionController.text,
      );
      widget.onSubmitNewEvent(newEvent);
      Navigator.pop(context, newEvent);
    }
  }

  int calculateDifferenceInMinutes(TimeOfDay time1, TimeOfDay time2) {
    int minutes1 = time1.hour * 60 + time1.minute;
    int minutes2 = time2.hour * 60 + time2.minute;
    int difference = (minutes1 - minutes2).abs();

    return difference;
  }

  bool isEarlier(TimeOfDay time1, TimeOfDay time2) {
    int minutes1 = time1.hour * 60 + time1.minute;
    int minutes2 = time2.hour * 60 + time2.minute;
    return minutes1 < minutes2;
  }

  @override
  Widget build(BuildContext context) {
    widget.isWithDayPicker = true;

    return AlertDialog(
      scrollable: true,
      title: Text("Create a new event"),
      content: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            child: Column(
              children: [
                Container(
                  width: 300,
                  child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Name of the event',
                        border: OutlineInputBorder(),
                      ),
                      controller: _eventTitleController),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 300, // Adjust the width as per your requirement
                  child: TextField(
                      maxLines: 5, // Allowing multiple lines for description
                      decoration: InputDecoration(
                        hintText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      controller: _eventDescriptionController),
                ),
                const SizedBox(height: 20),
                if (widget.isWithDayPicker)
                  IconButton(
                    onPressed: _presentDatePicker,
                    icon: const Icon(
                      Icons.calendar_month,
                    ),
                  ),
                IconButton(
                  // ! begin activity timer
                  onPressed: () {
                    _presentHourPicker(true);
                  },
                  icon: const Icon(
                    Icons.timer,
                  ),
                ),
                IconButton(
                  // ! end activity timer
                  onPressed: () {
                    _presentHourPicker(false);
                  },
                  icon: const Icon(
                    Icons.timer_outlined,
                  ),
                ),
              ],
            ),
          )),
      actions: [
        ElevatedButton(
            onPressed: () {
              _onSubmitNewEvent();
            },
            child: Text("Submit")),
      ],
    );
  }
}
