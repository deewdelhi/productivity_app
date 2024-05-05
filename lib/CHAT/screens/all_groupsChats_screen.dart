import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/CHAT/screens/chat_screen.dart';
import 'package:productivity_app/CHAT/screens/new_chat_screen.dart';
import 'package:productivity_app/SOCIAL/searchFriendsPage.dart';
import 'package:productivity_app/models/group.dart';
import 'package:productivity_app/models/user.dart';
import 'package:productivity_app/providers/repository_provider_CHAT.dart';
import 'package:productivity_app/providers/repository_provider_SOCIAL.dart';
import 'package:productivity_app/widgets/loader.dart';

class AllChatsScreen extends ConsumerWidget {
  const AllChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsForUser = ref.watch(groupsForUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My chats"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: const Text('Create new chat'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => NewGroupChatScreen(),
                      ),
                    );
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: groupsForUser.when(
        data: (groups) {
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              var groupData = groups[index];
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => ChatScreen(
                            groupName: groupData.name,
                            groupUid: groupData.groupId,
                            groupPic: groupData.groupPic,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          groupData.name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                groupData.lastMessage,
                                style: const TextStyle(fontSize: 15),
                              ),
                              Text(
                                DateFormat.yMd()
                                    .add_jm()
                                    .format(groupData.timeSent),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            groupData.groupPic,
                          ),
                          radius: 30,
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                child: const Text('See associated calendar'),
                                value: 'see_calendar',
                                // TODO: add logic for this
                              ),
                              PopupMenuItem(
                                child: const Text('Delete chat and calendar'),
                                value: 'delete_chat_calendar',
                                // TODO: add logic for this
                              ),
                              PopupMenuItem(
                                child: const Text('Edit group participants'),
                                value: 'edit_participants',
                                // TODO: add logic for this
                              ),
                              PopupMenuItem(
                                child: const Text('Edit group information'),
                                value: 'edit_information',
                                // TODO: add logic for this
                              ),
                            ];
                          },
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.black, indent: 85),
                ],
              );
            },
          );
        },
        loading: () => const Loader(),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
