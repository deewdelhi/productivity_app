import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/CALENDAR_USER/detailViewEvent.dart';
import 'package:productivity_app/CALENDAR_USER/models/myEvent.dart';
import 'package:productivity_app/CALENDAR_USER/time_planner.dart';
import 'package:productivity_app/CALENDAR_USER/utils.dart';
import 'package:productivity_app/providers/repository_provider_CALENDAR.dart';
import 'package:productivity_app/providers/user_provider.dart';
import 'package:productivity_app/widgets/loader.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_planner/time_planner.dart';

class TableEventsExample extends ConsumerStatefulWidget {
  var isSharedCalendar;

  TableEventsExample({required this.isSharedCalendar, super.key});

  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends ConsumerState<TableEventsExample> {
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

  void showDailyView(DateTime selectedDay, DateTime focusedDay) {
    _selectedEvents = _getEventsForDay(selectedDay);
    final currentUser = ref.watch(userProvider);

    print(_selectedEvents);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MyHomePage(
            title: "idk where this will be",
            selectedDate: selectedDay,
            listOfEvents: _selectedEvents,
            userId: currentUser.value!.uid),
      ),
    );
  }

  Future<void> fetchEventData() async {
    //**
    //
    //TODO: make the fetch for user separate form the fetch for a group calendar

    // */
    if (widget.isSharedCalendar) {
      final daysWithEvents = ref.watch(daysWithEventsProvider);
      daysWithEvents.when(
        data: (data) {
          for (var day in data) {
            final eventsForDayList = ref.watch(eventsForDayProvider(day));
            eventsForDayList.when(
              data: (eventsLists) {
                mapWithEvents[day] = eventsLists;
              },
              error: (error, stackTrace) => print(error),
              loading: () => print("loading events list"),
            );
          }
        },
        error: (error, stackTrace) => print(error),
        loading: () => print("loading"),
      );
    } else {
//* the fetch for the shared calendar
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchEventData();
    return Scaffold(
        body: Column(
      children: [
        TableCalendar<MyEvent>(
          onDayLongPressed: showDailyView,
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
                onTap: () => Navigator.of(context).push<EventDetailScreen>(
                  MaterialPageRoute(
                    builder: (ctx) =>
                        EventDetailScreen(event: _selectedEvents[index]),
                  ),
                ),
                title: Text('${_selectedEvents[index].title}'),
              ),
            );
          },
        )),
      ],
    ));
  }
}
