import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/CALENDAR_USER/models/myEvent.dart';
import 'package:productivity_app/CALENDAR_USER/newEvent_widget.dart';
import 'package:productivity_app/providers/repository_provider_CALENDAR.dart';
import 'package:time_planner/time_planner.dart';

class MyHomePage extends ConsumerStatefulWidget {
  MyHomePage(
      {Key? key,
      required this.title,
      required this.selectedDate,
      required this.listOfEvents,
      required this.userId})
      : super(key: key);

  final String title;
  final DateTime selectedDate;
  List<MyEvent> listOfEvents;
  String userId;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  List<TimePlannerTask> tasks = [];

  void _addObject(BuildContext context) {
    List<Color?> colors = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.lime[600]
    ];

    for (var event in widget.listOfEvents) {
      tasks.add(
        TimePlannerTask(
          dateTime: TimePlannerDateTime(
              day: 0,
              hour:
                  event.dateTime.hour - 1, // TODO: check this hack sigr nu e ok
              minutes: event.minutesDuration),
          event: event,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('You click on time planner object')));
          },
          child: Text(
            "${event.title} at hour ${event.dateTime}",
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
      );
    }

    setState(() {});
  }

  void _onSubmitNewEvent(MyEvent newEvent) {
    // Handle the returned value here

    ref.read(addEventProvider(newEvent));
  }

  @override
  Widget build(BuildContext context) {
    _addObject(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: TimePlanner(
          startHour: 0,
          endHour: 23,
          use24HourFormat: false,
          //setTimeOnAxis: false,
          style: TimePlannerStyle(
            cellHeight: 60,
            cellWidth: 310,
            showScrollBar: true,
            interstitialEvenColor: Colors.grey[50],
            interstitialOddColor: Colors.grey[200],
          ),
          headers: [
            TimePlannerTitle(
              date: DateFormat('dd/MM/yyyy').format(widget.selectedDate),
              title: DateFormat.EEEE().format(widget.selectedDate),
            ),
          ],
          tasks: tasks,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return newEventWidget(
                isWithDayPicker: false,
                onSubmitNewEvent: _onSubmitNewEvent,
                userId: widget.userId,
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
