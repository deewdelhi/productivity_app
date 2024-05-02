import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:productivity_app/models/user.dart';
import 'package:productivity_app/providers/repository_provider_SOCIAL.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage(
      {super.key,
      required this.users,
      required this.usersRequests,
      required this.usersFriends,
      required this.usersIncomingRequests});

  final List<MyUser> users;
  final List<String> usersFriends;
  final List<String> usersRequests;
  final List<String> usersIncomingRequests;

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  List<MyUser> _allFriends = [];
  List<MyUser> _filteredList = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      _allFriends = widget.users;
      _filteredList = _allFriends;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _filterFriendListBySearchText(String searchText) {
    setState(() {
      _filteredList = _allFriends
          .where((friend) =>
              friend.firstNmae.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
    print(_filteredList);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(5)),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () => FocusScope.of(context).unfocus(),
              ),
              suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    _textController.text = "";
                    _filterFriendListBySearchText("");
                  }),
              hintText: 'Search...',
              border: InputBorder.none,
            ),
            onChanged: (value) => _filterFriendListBySearchText(value),
            onSubmitted: (value) => _filterFriendListBySearchText(value),
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColorDark,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          screenSize.height * 0.05,
          screenSize.height * 0.1,
          screenSize.height * 0.05,
          0,
        ),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _filteredList.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 10),
          itemBuilder: (context, index) {
            MyUser user = _filteredList[index];
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
                  List<PopupMenuItem> menuItems = [];

                  if (widget.usersFriends.contains(user.id)) {
                    menuItems.add(
                      PopupMenuItem(
                        child: Text('Remove friend'),
                        onTap: () {
                          ref.read(removeFriendProvider(user.id));
                        },
                      ),
                    );
                  } else if (widget.usersRequests.contains(user.id)) {
                    menuItems.add(
                      PopupMenuItem(
                        child: Text('Undo request'),
                        onTap: () {
                          setState(() {
                            ref.read(undoFriendRequeestProvider(user.id));
                          });
                        },
                      ),
                    );
                  } else if (widget.usersIncomingRequests.contains(user.id)) {
                    menuItems.addAll([
                      PopupMenuItem(
                        child: Text('Delete user request'),
                        onTap: () {
                          setState(() {
                            ref.read(
                                addressFriendRequestProvider({user.id: false}));
                          });
                        },
                      ),
                      PopupMenuItem(
                        child: Text('Accept request'),
                        onTap: () {
                          ref.read(
                              addressFriendRequestProvider({user.id: true}));
                        },
                      ),
                    ]);
                  } else {
                    // Default option
                    menuItems.add(
                      PopupMenuItem(
                        child: Text('send request'),
                        onTap: () {
                          setState(() {
                            ref.read(sendFriendRequestProvider(user.id));
                          });
                        },
                      ),
                    );
                  }

                  return menuItems;
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
