import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/SOCIAL/repository/repository_friends.dart';
import 'package:productivity_app/models/user.dart';
import 'package:productivity_app/providers/user_provider.dart';

final firebaseRepositoryProvider = Provider<FirebaseRepositorySOCIAL>((ref) {
  return FirebaseRepositorySOCIAL();
});

//!  ==============================   GET LISTS PROVIDER   ==============================
final firendListsProvider = FutureProvider<List<List<String>>>((ref) async {
  final repository = ref.watch(firebaseRepositoryProvider);
  final user = ref.watch(userProvider);

  var lists = repository.fetchSocialStreamFromFirebase(user);
  var user_socialmanagement_lists = await lists;

  return user_socialmanagement_lists;
});
//!  ==============================   GET ALL USERS PROVIDER   ==============================

final allUsersProvider = StreamProvider<List<MyUser>>((ref) {
  final repository = ref.watch(firebaseRepositoryProvider);
  return repository.fetchAllUsersStreamFromFirebase();
});

//!  ==============================   GET FRIENDS PROVIDER  ==============================

final friendsProvider = Provider<List<MyUser>>((ref) {
  final users = ref.watch(allUsersProvider);
  final lists = ref.watch(firendListsProvider);

  List<List<String>> userLists = lists.value!;

  List<MyUser> allUsers = [];

  users.whenData((value) => {allUsers = value});

  List<MyUser> filteredUsers =
      allUsers.where((user) => userLists[0].contains(user.id)).toList();

  return filteredUsers;
});

//!  ==============================   SEND FRIEND REQUEST PROVIDER  ==============================

final sendFriendRequestProvider =
    FutureProvider.autoDispose.family((ref, String to_user) async {
  final repository = ref.watch(firebaseRepositoryProvider);
  final user = ref.watch(userProvider);
  return repository.sendFriendRequestToFirestore(user.value!.uid, to_user);
});

//!  ==============================   ADDRESS FRIEND REQUEST PROVIDER  ==============================

final addressFriendRequestProvider =
    FutureProvider.autoDispose.family((ref, Map<String, bool> data) async {
  final repository = ref.watch(firebaseRepositoryProvider);
  final user = ref.watch(userProvider);
  String from_user = data.keys.first;
  bool acceptRequest = data[from_user]!;
  return repository.addressFriendRequest(
      user.value!.uid, from_user, acceptRequest);
});

//!  ==============================   REMOVE FRIEND REQUEST PROVIDER  ==============================
final removeFriendProvider =
    FutureProvider.autoDispose.family((ref, String exFriend) async {
  final repository = ref.watch(firebaseRepositoryProvider);
  final user = ref.watch(userProvider);
  return repository.removeFriendFirestore(user.value!.uid, exFriend);
});

//!  ==============================   UNDO FRIEND REQUEST PROVIDER  ==============================

final undoFriendRequeestProvider =
    FutureProvider.autoDispose.family((ref, String exFriend) async {
  final repository = ref.watch(firebaseRepositoryProvider);
  final user = ref.watch(userProvider);
  return repository.undoFriendRequestFirestore(user.value!.uid, exFriend);
});
