import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/CALENDAR_USER/calendar.dart';
import 'package:productivity_app/CHAT/screens/all_groupsChats_screen.dart';
import 'package:productivity_app/CHAT/screens/chat_screen.dart';
import 'package:productivity_app/TODO/all_todo_lists.dart';
import 'package:productivity_app/SOCIAL/friendsScreen.dart';
import 'package:productivity_app/providers/user_provider.dart';
import 'package:productivity_app/widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'Sign out') {
      FirebaseAuth.instance.signOut();
    } else if (identifier == "friends") {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => FriendsScreen(),
        ),
      );
    } else if (identifier == "chats") {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => AllChatsScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    Widget activePage = AllToDoListsScreen();
    //Widget activePage = MobileChatScreen(
    //   name: "olaaaa",
    //   uid: "lkdsjfsd",
    //   isGroupChat: true,
    //   profilePic: "s;lf",
    // );

    var activePageTitle = 'ToDos';

    if (_selectedPageIndex == 0) {
      activePage = TableEventsExample(
        isSharedCalendar: true,
      );
      activePageTitle = 'Your Calendar';
    }

    print(_selectedPageIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle + user.value!.email!),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'ToDo',
          ),
        ],
      ),
    );
  }
}
