import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/CALENDAR/calendar.dart';
import 'package:productivity_app/TODO/all_todo_lists.dart';
import 'package:productivity_app/SOCIAL/friendsScreen.dart';

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

  @override
  Widget build(BuildContext context) {
    Widget activePage = AllToDoListsScreen();
    var activePageTitle = 'ToDos';

    if (_selectedPageIndex == 0) {
      //final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = TableComplexExample();
      activePageTitle = 'Your Calendar';
    }

    if (_selectedPageIndex == 2) {
      //final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = FriendsScreen();
      activePageTitle = 'Your Friends';
    }
    print(_selectedPageIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_sharp),
            label: 'ToDo',
          ),
        ],
      ),
    );
  }
}
