import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/TODO/models/task.dart';
import 'package:productivity_app/TODO/models/todo.dart';
import 'package:productivity_app/TODO/repository/repository_todo.dart';
import 'package:productivity_app/providers/user_provider.dart';

final firebaseRepositoryProvider = Provider<FirebaseRepositoryTODO>((ref) {
  return FirebaseRepositoryTODO();
});

//!  ==============================   GET DATA PROVIDER   ==============================
final todosProvider = StreamProvider<List<Todo>>((ref) {
  final repository = ref.watch(firebaseRepositoryProvider);
  final user = ref.watch(userProvider);
  return repository.fetchDataStreamFromFirebase(user);
});
final tasksProvider =
    StreamProvider.family<List<MyTask>, String>((ref, todoId) {
  final repository = ref.watch(firebaseRepositoryProvider);
  final user = ref.watch(userProvider);
  return repository.getTasksForTodoFirestore(user, todoId);
});
//!  ==============================   ADD DATA PROVIDER   ==============================
final addTodoProvider =
    FutureProvider.autoDispose.family((ref, Todo todo) async {
  final repository = ref.watch(firebaseRepositoryProvider);
  final user = ref.watch(userProvider);
  return repository.addTodoToFirebase(user, todo);
});

final addTaskProvider =
    FutureProvider.autoDispose.family((ref, Map<String, MyTask> data) async {
  final repository = ref.watch(firebaseRepositoryProvider);
  final user = ref.watch(userProvider);
  return repository.addTaskToFirebase(user, data);
});

//!  ==============================   DELETE DATA PROVIDER   ==============================

final deleteCollectionProvider =
    FutureProvider.family<void, String>((ref, String todoId) async {
  final repository = ref.watch(firebaseRepositoryProvider);
  final user = ref.watch(userProvider);
  await repository.deleteCollection(user, todoId);
});

final deleteTaskProvider =
    FutureProvider.family<void, List<String>>((ref, List<String> ids) async {
  final repository = ref.watch(firebaseRepositoryProvider);
  final user = ref.watch(userProvider);
  await repository.deleteTask(user, ids);
});




//!  ==============================   UPDATE DATA PROVIDER   ==============================

