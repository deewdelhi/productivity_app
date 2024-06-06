import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/CALENDAR_USER/models/myEvent.dart';
import 'package:productivity_app/CALENDAR_USER/repository/repository_calendar.dart';
import 'package:productivity_app/providers/user_provider.dart';
import 'package:time_planner/time_planner.dart';

final firebaseRepositoryProvider = Provider<FirebaseRepositoryCALENDAR>((ref) {
  return FirebaseRepositoryCALENDAR();
});

//!  ==============================   ADD EVENTS PROVIDER   ==============================
final addEventProvider =
    FutureProvider.autoDispose.family((ref, MyEvent newEvent) async {
  final repository = ref.watch(firebaseRepositoryProvider);
  final user = ref.watch(userProvider);
  return repository.addEventToFirestore(user, newEvent);
});

//!  ==============================   GET EVENTS PROVIDER   ==============================

final daysWithEventsProvider = StreamProvider<List<String>>((ref) {
  print(" inside the day with events provider");

  final user = ref.watch(userProvider);
  final repository = ref.watch(firebaseRepositoryProvider);
  return repository.getDatesWithEventsFirestore(user.value!.uid);
});

final eventsForDayProvider =
    StreamProvider.family<List<MyEvent>, String>((ref, date) {
  final user = ref.watch(userProvider);
  final repository = ref.watch(firebaseRepositoryProvider);
  return repository.getEventsForDateFromFirestore(user.value!.uid, date);
});

//------------------------------------------------------

final daysWithEventsProvider_otherUsers =
    StreamProvider.family<List<String>, String>((ref, userId) {
  final repository = ref.watch(firebaseRepositoryProvider);
  return repository.getDatesWithEventsFirestore(userId);
});

final eventsForDayProvider_otherUsers =
    StreamProvider.family<List<MyEvent>, List<String>>((ref, data) {
  // data[0] ->  userId; data[1] -> date
  final repository = ref.watch(firebaseRepositoryProvider);
  final user_id = data[0];
  final day = data[1];
  return repository.getEventsForDateFromFirestore(user_id, day);
});

//!  ==============================   DELETE EVENT  PROVIDER   ==============================

final deleteEventProvider =
    FutureProvider.family<void, List<String>>((ref, List<String> ids) async {
  final repository = ref.watch(firebaseRepositoryProvider);
  final user = ref.watch(userProvider);
  await repository.deleteEvent(user, ids);
});

// final allEventsProvider = StreamProvider.autoDispose
//     .family<List<MyEvent>, List<String>>((ref, userIds) {
//   print(" am in the provider");
//   final repository = ref.watch(firebaseRepositoryProvider);
//   var listWithDatesForallUsrs = [];
//   print("before for");

//   for (final user in userIds) {
//     print(user);
//     var listWithDates = ref.watch(
//         repository.getDatesWithEventsFirestore(user) as ProviderListenable);
//     print("after watch");
//     listWithDatesForallUsrs.addAll(listWithDates);
//   }
//   print("outside for");

//   print(listWithDatesForallUsrs);
//   return repository.getEventsForDateFromFirestore(userIds[0], "smkkjdkf");

//   // // Create a list of all dates streams for all users
//   // final dateStreams = userIds.map((userId) {
//   //  ref.watch(repository.getDatesWithEventsFirestore(userId));
//   // }).toList();

//   // // Combine all dates streams
//   // return CombineLatestStream.list(dateStreams).asyncExpand((dateLists) {
//   //   // Flatten the lists of dates and remove duplicates
//   //   final allDates = dateLists.expand((dates) => dates).toSet().toList();

//   //   // Create a list of event streams for each date for each user
//   //   final eventStreams = userIds.expand((userId) {
//   //     return allDates.map((date) {
//   //       return ref.watch(eventsForDateProvider({'userId': userId, 'date': date}).stream);
//   //     });
//   //   }).toList();

//   //   // Combine all event streams into a single stream
//   //   return CombineLatestStream.list(eventStreams).map((eventsLists) {
//   //     return eventsLists.expand((events) => events).toList();
//   //   });
//   // });
//});
