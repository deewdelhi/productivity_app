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

class NewGroupChatScreen extends ConsumerStatefulWidget {
  @override
  _NewGroupChatScreenState createState() => _NewGroupChatScreenState();
}

class _NewGroupChatScreenState extends ConsumerState<NewGroupChatScreen> {
  File? _selectedImage;
  List<MyUser> _selectedFriends = [];

  void _submit() async {
    if (_selectedFriends.isEmpty) return;

    final currentUser = ref.watch(userProvider);

    var rng = Random().nextInt(237) + 1;
    String imageUrl = "https://placedog.net/800/640?id=${rng}";
    String groupID = uuid.v4();

    String title = _titleController.text.isNotEmpty
        ? _titleController.text
        : _generateRandomFunnyName();

    List<String> listMembers =
        _selectedFriends.map((friend) => friend.id).toList();

    if (_selectedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref() // just a reference to our firebase storage so that we can modify it
          .child('group_images') // to create a new path in the folder
          .child('${groupID}.jpg');
      await storageRef.putFile(_selectedImage!); // to put the file to that path
      imageUrl = await storageRef
          .getDownloadURL(); // we need this so that later we can actually use and display that image and that s why we put it later in image_url
    }
    // TODO: pune si asta in provider ca nu da tare bine aici

    final newGroup = Group(
      senderId: currentUser.value!.uid,
      name: title,
      groupId: groupID,
      lastMessage: 'New group was created',
      groupPic: imageUrl, // Placeholder URL
      membersUid: listMembers,
      timeSent: DateTime.now(),
    );
    ref.read(createGroupProvider(newGroup));

    Navigator.of(context).pop();
  }

  TextEditingController _searchController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  final List<String> _funnyNames = [
    'The Dynamic Dozen',
    'The Awesome Alliance',
    'The Wacky Wizards',
    'The Quirky Quartet',
    'The Jolly Jesters',
    'The Silly Squad',
    'The Happy Huddle',
    'The Crazy Collective',
    'The Funky Friends',
    'The Laughing Llamas',
    'The Joyful Jamboree',
    'The Cheerful Crew',
  ];

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

  String _generateRandomFunnyName() {
    final random = Random();
    return _funnyNames[random.nextInt(_funnyNames.length)];
  }

  @override
  Widget build(BuildContext context) {
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
          UserImagePicker(onPickImage: (pickedImage) {
            _selectedImage = pickedImage;
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter group chat title (optional)',
              ),
            ),
          ),
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
