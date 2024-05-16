import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/CALENDAR/models/myEvent.dart';
import 'package:productivity_app/CALENDAR/repository/repository_calendar.dart';
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

//!  ==============================   ADD EVENTS PROVIDER   ==============================

final daysWithEventsProvider = StreamProvider<List<String>>((ref) {
  final user = ref.watch(userProvider);
  final repository = ref.watch(firebaseRepositoryProvider);
  return repository.getDatesWithEventsFirestore(user);
});

final eventsForDayProvider =
    StreamProvider.family<List<MyEvent>, String>((ref, date) {
  final user = ref.watch(userProvider);
  final repository = ref.watch(firebaseRepositoryProvider);
  return repository.getEventsForDateFromFirestore(user, date);
});
