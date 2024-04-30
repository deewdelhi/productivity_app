import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/SOCIAL/searchFriendsPage.dart';
import 'package:productivity_app/models/user.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  FriendsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FriendsScreenState();
  }
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  List<MyUser> users = [];
  @override
  void initState() {
    super.initState();
    users = [
      MyUser(
        id: '1',
        firstNmae: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '2',
        firstNmae: 'Jane',
        lastName: 'Smith',
        email: 'jane@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '3',
        firstNmae: 'Alice',
        lastName: 'Johnson',
        email: 'alice@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '4',
        firstNmae: 'Bob',
        lastName: 'Brown',
        email: 'bob@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '5',
        firstNmae: 'Emily',
        lastName: 'White',
        email: 'emily@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '6',
        firstNmae: 'Michael',
        lastName: 'Clark',
        email: 'michael@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '7',
        firstNmae: 'David',
        lastName: 'Lee',
        email: 'david@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '8',
        firstNmae: 'Sarah',
        lastName: 'Taylor',
        email: 'sarah@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '9',
        firstNmae: 'Jennifer',
        lastName: 'Hall',
        email: 'jennifer@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '10',
        firstNmae: 'Christopher',
        lastName: 'Lewis',
        email: 'christopher@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '11',
        firstNmae: 'Jessica',
        lastName: 'Martinez',
        email: 'jessica@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '12',
        firstNmae: 'James',
        lastName: 'Garcia',
        email: 'james@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '13',
        firstNmae: 'Daniel',
        lastName: 'Martinez',
        email: 'daniel@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '14',
        firstNmae: 'Lisa',
        lastName: 'Jones',
        email: 'lisa@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '15',
        firstNmae: 'Mark',
        lastName: 'Hernandez',
        email: 'mark@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '16',
        firstNmae: 'Paul',
        lastName: 'Young',
        email: 'paul@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '17',
        firstNmae: 'Kimberly',
        lastName: 'Walker',
        email: 'kimberly@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '18',
        firstNmae: 'Richard',
        lastName: 'Brown',
        email: 'richard@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '19',
        firstNmae: 'Mary',
        lastName: 'Taylor',
        email: 'mary@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
      MyUser(
        id: '20',
        firstNmae: 'Matthew',
        lastName: 'Thompson',
        email: 'matthew@example.com',
        pictureUrl: 'https://via.placeholder.com/150',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SearchPage(
                        users: this.users,
                      ))),
              icon: Icon(
                Icons.search_rounded,
                color: Theme.of(context).primaryColorDark,
              )),
        ],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          MyUser user = users[index];
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
      ),
    );
  }
}
