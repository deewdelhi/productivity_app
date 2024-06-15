import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/SOCIAL/searchFriendsPage.dart';
import 'package:productivity_app/models/user.dart';
import 'package:productivity_app/providers/repository_provider_SOCIAL.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  FriendsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FriendsScreenState();
  }
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    //    list with all users on the app (MyUser obj)
    final users = ref.watch(allUsersProvider);
    List<MyUser> allUsers = [];
    users.whenData((value) => allUsers = value);

    // list with all the freinds for the user (MyUser obj)
    final userFriends = ref.watch(friendsProvider);

    // list with social managememts data [[],[],[]]
    final userSocialManagementLists = ref.watch(firendListsProvider).value!;

    // TODO here check if you have any incoming requests so you can manage them ebfore you can see your own list of friends

    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SearchPage(
                        users: allUsers,
                        usersFriends: userSocialManagementLists[0],
                        usersRequests: userSocialManagementLists[2],
                        usersIncomingRequests: userSocialManagementLists[1],
                      ))),
              icon: Icon(
                Icons.search_rounded,
                color: Theme.of(context).primaryColorDark,
              )),
        ],
      ),
      body: userFriends.length > 0
          ? ListView.builder(
              itemCount: userFriends.length,
              itemBuilder: (context, index) {
                MyUser user = userFriends[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.pictureUrl),
                  ),
                  title: Text(user.firstNmae),
                  subtitle: Text(
                    user.email,
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    //close(context, user.username);
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
            )
          : Center(child: Text("no friends bud ")),
    );
  }
}
