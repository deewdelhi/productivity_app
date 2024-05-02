import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/CALENDAR/calendar.dart';
import 'package:productivity_app/TODO/all_todo_lists.dart';
import 'package:productivity_app/SOCIAL/friendsScreen.dart';
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
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = AllToDoListsScreen();
    var activePageTitle = 'ToDos';

    if (_selectedPageIndex == 0) {
      activePage = TableComplexExample();
      activePageTitle = 'Your Calendar';
    }

    print(_selectedPageIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
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
