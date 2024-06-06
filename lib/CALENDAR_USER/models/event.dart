import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
//Generate a v4 (random) id
//uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'

// final kEvents = LinkedHashMap<DateTime, List<MyEvent>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);

// final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
//     key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
//     value: (item) => List.generate(
//         item % 4 + 1, (index) => MyEvent('Event $item | ${index + 1}')))
//   ..addAll({
//     kToday: [
//       MyEvent(id: uuid.v4(), title: "Today's Event 1"),
//       MyEvent(id: uuid.v4(), title: "Today's Event 2"),
//     ],
//   });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
