import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/CALENDAR/models/myEvent.dart';
import 'package:productivity_app/CALENDAR/newEvent_widget.dart';
import 'package:productivity_app/providers/repository_provider_CALENDAR.dart';
import 'package:time_planner/time_planner.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.selectedDate})
      : super(key: key);

  final String title;
  final DateTime selectedDate;

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

    // setState(() {
    //   tasks.add(
    //     TimePlannerTask(
    //       title: "some title here oricum nu e folosit inca",
    //       id: " to add uuid for this",
    //       color: colors[Random().nextInt(colors.length)],
    //       dateTime: TimePlannerDateTime(
    //           day: Random().nextInt(1),
    //           hour: Random().nextInt(18) + 6,
    //           minutes: Random().nextInt(60)),
    //       minutesDuration: Random().nextInt(90) + 30,
    //       daysDuration: Random().nextInt(4) + 1,
    //       onTap: () {
    //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //             content: Text('You click on time planner object')));
    //       },
    //       child: Text(
    //         'this is a demo',
    //         style: TextStyle(color: Colors.grey[350], fontSize: 12),
    //       ),
    //     ),
    //   );
    // }
    // );

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Random task added to time planner!')));
  }

  void _onSubmitNewEvent(MyEvent newEvent) {
    // Handle the returned value here
    print('Received new event: $newEvent');
    ref.read(addEventProvider(newEvent));
  }

  // void _onFloatingActionButtonPressed(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => newEventWidget(
  //         onSubmitNewEvent: _onSubmitNewEvent,
  //         isWithDayPicker: true,
  //       ),
  //     ),
  //   ).then((result) {
  //     if (result != null) {
  //       print("dsssssssssssssssssssssssssssssssssssss");
  //       print(result);
  //       setState(() {
  //         // Update the state with the result
  //         // tasks.add(result);
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: TimePlanner(
          startHour: 6,
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
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
