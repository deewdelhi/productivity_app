import 'package:flutter/material.dart';
import 'package:productivity_app/TODO/models/priority.dart';
import 'package:productivity_app/TODO/models/todo.dart';
import 'package:productivity_app/TODO/widgets/grid_items/task_grid_item.dart';
import 'package:productivity_app/TODO/widgets/new_objects/new_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/providers/repository_provider_TODO.dart';
import 'package:productivity_app/providers/user_provider.dart';
import 'package:productivity_app/TODO/models/task.dart';

class ToDoListScreen extends ConsumerStatefulWidget {
  ToDoListScreen({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  ConsumerState<ToDoListScreen> createState() {
    return _ToDoListScreenState();
  }
}

class _ToDoListScreenState extends ConsumerState<ToDoListScreen> {
  final _drawerKey = GlobalKey<ScaffoldState>();
  final Map<Priorities, bool> _filterOptions = {
    Priorities.high: true,
    Priorities.medium: true,
    Priorities.low: true,
  };

  bool _sortByHighToLow = false;

  void _addTask(AsyncValue<User?> user) async {
    var nTask = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => NewTask(),
      ),
    );

    if (nTask != null) {
      Map<String, MyTask> data = {
        widget.todo.id: nTask,
      };
      ref.read(addTaskProvider(data));
    }
  }

  void _toggleFilter(Priorities priority) {
    setState(() {
      _filterOptions[priority] = !_filterOptions[priority]!;
    });
  }

  List<MyTask> _applyFilters(List<MyTask> tasks) {
    return tasks.where((task) {
      return _filterOptions[task.priority] ?? false;
    }).toList();
  }

  void _toggleSort() {
    setState(() {
      _sortByHighToLow = !_sortByHighToLow;
    });
  }

  List<MyTask> _sortTasks(List<MyTask> tasks) {
    if (_sortByHighToLow) {
      tasks.sort((a, b) {
        if (a.priority == b.priority) {
          return 0;
        } else if (a.priority == Priorities.high) {
          return -1;
        } else if (b.priority == Priorities.high) {
          return 1;
        } else if (a.priority == Priorities.medium) {
          return -1;
        } else if (b.priority == Priorities.medium) {
          return 1;
        } else {
          return 0;
        }
      });
    } else {
      tasks.sort((a, b) {
        if (a.priority == b.priority) {
          return 0;
        } else if (a.priority == Priorities.low) {
          return -1;
        } else if (b.priority == Priorities.low) {
          return 1;
        } else if (a.priority == Priorities.medium) {
          return -1;
        } else if (b.priority == Priorities.medium) {
          return 1;
        } else {
          return 0;
        }
      });
    }
    return tasks;
  }

  void _resetFiltersAndSort() {
    setState(() {
      _filterOptions[Priorities.high] = true;
      _filterOptions[Priorities.medium] = true;
      _filterOptions[Priorities.low] = true;
      _sortByHighToLow = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final taskList = ref.watch(tasksProvider(widget.todo.id));

    return Scaffold(
      key: _drawerKey,
      appBar: AppBar(
        title: Text(widget.todo.title),
        actions: [
          IconButton(
            onPressed: () {
              _addTask(user);
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              _drawerKey.currentState?.openEndDrawer();
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, // Use app primary color
              ),
              child: Center(
                child: Text(
                  'Filter by Priority',
                  style: TextStyle(
                    fontSize: 18, // Adjust the font size as needed
                    color: Colors.white, // Text color
                  ),
                ),
              ),
            ),
            CheckboxListTile(
              title: Text('High'),
              value: _filterOptions[Priorities.high],
              onChanged: (bool? value) {
                _toggleFilter(Priorities.high);
              },
            ),
            CheckboxListTile(
              title: Text('Medium'),
              value: _filterOptions[Priorities.medium],
              onChanged: (bool? value) {
                _toggleFilter(Priorities.medium);
              },
            ),
            CheckboxListTile(
              title: Text('Low'),
              value: _filterOptions[Priorities.low],
              onChanged: (bool? value) {
                _toggleFilter(Priorities.low);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _toggleSort();
                    },
                    child: Text(_sortByHighToLow
                        ? 'Sort by Priority: High to Low'
                        : 'Sort by Priority: Low to High'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _resetFiltersAndSort();
                    },
                    child: Text('Reset Filters and Sorting'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Show Data'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: taskList.when(
        data: (data) {
          var filteredTasks = _applyFilters(data);
          var sortedTasks = _sortTasks(filteredTasks);
          return Center(
            child: GridView(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 10,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              children: [
                for (final task in sortedTasks)
                  TaskGridItem(
                    task: task,
                    todoId: widget.todo.id,
                  ),
              ],
            ),
          );
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
      ),
    );
  }
}
