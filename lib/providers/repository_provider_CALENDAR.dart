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
