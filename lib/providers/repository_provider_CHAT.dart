import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/CHAT/repository/repository_chat.dart';
import 'package:productivity_app/models/group.dart';
import 'package:productivity_app/models/message.dart';
import 'package:productivity_app/providers/user_provider.dart';

final firebaseRepositoryProvider = Provider<FirebaseRepositoryCHAT>((ref) {
  return FirebaseRepositoryCHAT();
});

//!  ==============================   CREATE NEW GROUP PROVIDER   ==============================
final createGroupProvider =
    FutureProvider.autoDispose.family((ref, Group group) async {
  final repository = ref.watch(firebaseRepositoryProvider);
  return repository.createNewGroup(group);
});

//!  ==============================   GET GROUPS FOR USER   ==============================
final groupsForUserProvider = StreamProvider<List<Group>>((ref) {
  final user = ref.watch(userProvider);
  final repository = ref.watch(firebaseRepositoryProvider);
  return repository.getGroupsForUser(user.value!.uid);
});

final usersForGroupProvider =
    StreamProvider.autoDispose.family<List<String>, String>((ref, groupId) {
  // final user = ref.watch(userProvider);
  final repository = ref.watch(firebaseRepositoryProvider);
  print("I AM INSIDE THE PROVIDEEER");
  return repository.getUsersForGroup(groupId);
});

//!  ==============================   SEND TEXT MESSAGE PROVIDER   ==============================
final sendTextMessageProvider =
    FutureProvider.autoDispose.family((ref, List<String> data) async {
  final user = ref.watch(userProvider);
  final repository = ref.watch(firebaseRepositoryProvider);
  return repository.sendTextMessageToFirestore(
      data[0], user.value!.uid, data[1]);
});

//!  ==============================   SEND FILE MESSAGE PROVIDER   ==============================
final sendFileMessageProvider =
    FutureProvider.autoDispose.family((ref, Map<String, File?> data) async {
  final strings = data.keys.toList();
  var groupId = strings[1];
  var message_type = strings[0];
  var message = data[message_type]!;

  final user = ref.watch(userProvider);
  final repository = ref.watch(firebaseRepositoryProvider);
  return repository.sendFileMessageToFirestore(
      message_type, message, user.value!.uid, groupId);
});

//!  ==============================   GET MESSAGEST FOR GROUP PROVIDER   ==============================

final groupChatStreamProvider =
    StreamProvider.family<List<Message>, String>((ref, groupId) {
  final repository = ref.watch(firebaseRepositoryProvider);
  return repository.getGroupChatStream(groupId);
});

//!  ==============================   SEND GIF PROVIDER   ==============================
final sendGIFMessageProvider =
    FutureProvider.autoDispose.family((ref, List<String> data) async {
  final user = ref.watch(userProvider);
  final repository = ref.watch(firebaseRepositoryProvider);
  int gifUrlPartIndex = data[0].lastIndexOf('-') + 1;
  String gifUrlPart = data[0].substring(gifUrlPartIndex);
  String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
  return repository.sendGifMessageToFirestore(
      newgifUrl, user.value!.uid, data[1]);
});

//!  ==============================   DELETE GROUP PROVIDER   ==============================

final deleteGroupProvider =
    FutureProvider.family<void, String>((ref, String groupId) async {
  final repository = ref.watch(firebaseRepositoryProvider);

  await repository.deleteEntireGroup(groupId);
});

//!  ==============================   UPDATE GROUP MEMBERS PROVIDER   ==============================

final updateGroupMembersProvider = FutureProvider.autoDispose
    .family((ref, Map<String, List<String>> data) async {
  final repository = ref.watch(firebaseRepositoryProvider);

  String groupId = data.keys.first;

  List<String> newMembers = data[groupId]!;

  return repository.updateGroupMembersFirestore(groupId, newMembers);
});


//!  ==============================   --   ==============================