import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/CHAT/repository/repository_chat.dart';
import 'package:productivity_app/SOCIAL/repository/repository_friends.dart';
import 'package:productivity_app/models/group.dart';
import 'package:productivity_app/models/message.dart';
import 'package:productivity_app/models/user.dart';
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

//!  ==============================   SEND TEXT MESSAGE PROVIDER   ==============================
final sendTextMessageProvider =
    FutureProvider.autoDispose.family((ref, List<String> data) async {
  print("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
  final user = ref.watch(userProvider);
  final repository = ref.watch(firebaseRepositoryProvider);
  return repository.sendTextMessageToFirestore(
      data[0], user.value!.uid, data[1]);
});

//!  ==============================   GET MESSAGEST FOR GROUP PROVIDER   ==============================

final groupChatStreamProvider =
    StreamProvider.family<List<Message>, String>((ref, groupId) {
  final repository = ref.watch(firebaseRepositoryProvider);
  return repository.getGroupChatStream(groupId);
});



//!  ==============================   --   ==============================
//!  ==============================   --   ==============================
//!  ==============================   --   ==============================
//!  ==============================   --   ==============================