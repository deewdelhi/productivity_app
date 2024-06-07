import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/models/group.dart';
import 'package:productivity_app/models/user.dart';
import 'package:productivity_app/providers/repository_provider_CHAT.dart';
import 'package:productivity_app/providers/repository_provider_SOCIAL.dart';
import 'package:productivity_app/providers/user_provider.dart';
import 'package:productivity_app/widgets/image_upload.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // in the firestore there is data NOT files
import 'package:firebase_storage/firebase_storage.dart';

var uuid = Uuid();

class EditGroupMembersScreen extends ConsumerStatefulWidget {
  var groupId;

  EditGroupMembersScreen({required this.groupId, super.key});

  @override
  _EditGroupMembersScreenState createState() => _EditGroupMembersScreenState();
}

class _EditGroupMembersScreenState
    extends ConsumerState<EditGroupMembersScreen> {
  List<MyUser> _selectedFriends = [];

  void _submit() async {
    if (_selectedFriends.isEmpty) return;

    List<String> listMembers =
        _selectedFriends.map((friend) => friend.id).toList();

    ref.read(updateGroupMembersProvider({widget.groupId: listMembers}));

    Navigator.of(context).pop();
  }

  TextEditingController _searchController = TextEditingController();

  void _toggleFriendSelection(MyUser friend) {
    setState(() {
      if (_selectedFriends.contains(friend)) {
        _selectedFriends.remove(friend);
      } else {
        _selectedFriends.add(friend);
      }
    });
  }

  void _removeSelectedFriend(MyUser friend) {
    setState(() {
      _selectedFriends.remove(friend);
    });
  }

  List<MyUser> _filteredFriends(String query) {
    final userFriends = ref.watch(friendsProvider);

    return userFriends
        .where((friend) =>
            (friend.lastName + friend.firstNmae + friend.username)
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
  }

  void setSelectedFriends() {
    final userFriends = ref.watch(friendsProvider);
    var members = ref.watch(usersForGroupProvider(widget.groupId));
    List<String> membersList = members.value!;

    List<MyUser> selectedUsers =
        userFriends.where((user) => membersList.contains(user.id)).toList();
    _selectedFriends = selectedUsers;
  }

  @override
  Widget build(BuildContext context) {
    setSelectedFriends();
    return Scaffold(
      appBar: AppBar(
        title: Text('New Group Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _submit,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search friends...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredFriends(_searchController.text).length,
              itemBuilder: (context, index) {
                MyUser friend = _filteredFriends(_searchController.text)[index];
                return ListTile(
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(friend.pictureUrl),
                      ),
                      SizedBox(width: 10),
                      Text('${friend.firstNmae} ${friend.lastName}'),
                    ],
                  ),
                  leading: Checkbox(
                    value: _selectedFriends.contains(friend),
                    onChanged: (value) {
                      _toggleFriendSelection(friend);
                    },
                  ),
                  subtitle: Text(
                    friend.email,
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    // Add functionality for tapping on a friend tile if needed
                  },
                  trailing: PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          child: Text('Delete'),
                          value: 'delete',
                        ),
                      ];
                    },
                  ),
                );
              },
            ),
          ),
          Divider(),
          Text(
            'Selected Friends:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView(
              children: _selectedFriends.map((friend) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(friend.pictureUrl),
                  ),
                  title: Text('${friend.firstNmae} ${friend.lastName}'),
                  subtitle: Text(
                    friend.email,
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      _removeSelectedFriend(friend);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
