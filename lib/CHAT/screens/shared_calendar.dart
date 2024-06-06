import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/CALENDAR_USER/detailViewEvent.dart';
import 'package:productivity_app/CALENDAR_USER/models/myEvent.dart';
import 'package:productivity_app/CALENDAR_USER/time_planner.dart';
import 'package:productivity_app/CALENDAR_USER/utils.dart';
import 'package:productivity_app/providers/repository_provider_CALENDAR.dart';
import 'package:productivity_app/providers/repository_provider_CHAT.dart';
import 'package:productivity_app/providers/user_provider.dart';
import 'package:productivity_app/widgets/loader.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_planner/time_planner.dart';

class SharedCalendar extends ConsumerStatefulWidget {
  var groupId;

  SharedCalendar({required this.groupId, super.key});

  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends ConsumerState<SharedCalendar> {
  List<MyEvent> _selectedEvents = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Map<String, List<MyEvent>> mapWithEvents = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<MyEvent> _getEventsForDay(DateTime day) {
    String dateFormatedForKey = DateFormat('dd_MM_yyyy').format(day);
    print("events for day ${day}:  ${mapWithEvents[dateFormatedForKey]}  ");

    return mapWithEvents[dateFormatedForKey] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents = _getEventsForDay(selectedDay);
    }
  }

  // void showDailyView(DateTime selectedDay, DateTime focusedDay) {
  //   _selectedEvents = _getEventsForDay(selectedDay);
  //   final currentUser = ref.watch(userProvider);

  //   print(_selectedEvents);
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (ctx) => MyHomePage(
  //           title: "idk where this will be",
  //           selectedDate: selectedDay,
  //           listOfEvents: _selectedEvents,
  //           userId: currentUser.value!.uid),
  //     ),
  //   );
  // }

  Future<void> fetchEventData() async {
    List<MyEvent> listWithAllEvents = [];
    String groupId = widget.groupId;

    // Fetch members for the group
    var membersForGroup = await ref.read(usersForGroupProvider(groupId).future);

    // Check if membersForGroup is null or empty and handle accordingly
    if (membersForGroup == null || membersForGroup.isEmpty) {
      print("No members found for the group.");
      return;
    }

    List<String> userIDSList = List<String>.from(membersForGroup);
    print("MEMBEEEEEEEEEEEERS : ${userIDSList}");

    List<Future<void>> futures = [];

    for (var usr in userIDSList) {
      var daysWithEventsFuture =
          ref.watch(daysWithEventsProvider_otherUsers(usr).future);
      // TODO : merge prvatul dar uita te ce dracu ca tot incarca event urile la fiecare si nu si da overide ci isi tot adauga chestii

      futures.add(daysWithEventsFuture.then((data) async {
        for (var day in data) {
          var eventsForDayListFuture =
              ref.watch(eventsForDayProvider_otherUsers([usr, day]).future);

          await eventsForDayListFuture.then((eventsLists) {
            listWithAllEvents.addAll(eventsLists);
            //mapWithEvents[day]!.addAll(eventsLists);
            if (mapWithEvents[day] != null) {
              mapWithEvents[day]!.addAll(eventsLists);
            } else {
              mapWithEvents[day] = eventsLists;
            }
          }).catchError((error) {
            print(error);
          });
        }
      }).catchError((error) {
        print(error);
      }));
    }

    await Future.wait(futures);

    print(" LIST WITH ALL EVENTSl: ${listWithAllEvents}");
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(userProvider);
    fetchEventData();
    return Scaffold(
        appBar: AppBar(
          title: Text('TableCalendar - Events'),
        ),
        body: Column(
          children: [
            TableCalendar<MyEvent>(
              //onDayLongPressed: showDailyView,
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
              ),
              onDaySelected: _onDaySelected,
              // onRangeSelected: _onRangeSelected,
              // TODO: maybe add also range ?????
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
                child: ListView.builder(
              itemCount: _selectedEvents.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                      onTap: () =>
                          Navigator.of(context).push<EventDetailScreen>(
                            MaterialPageRoute(
                              builder: (ctx) => EventDetailScreen(
                                  event: _selectedEvents[index]),
                            ),
                          ),
                      // title: Text('${_selectedEvents[index].title}'),
                      title: _selectedEvents[index].userId == userId.value!.uid
                          ? Text('${_selectedEvents[index].title}')
                          : Text(
                              'private event')), // TODO try to display here the user who has that event
                );
              },
            )),
          ],
        ));
  }
}
