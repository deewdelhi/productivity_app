import 'package:flutter/material.dart';
import 'package:productivity_app/TODO/models/todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/providers/user_provider.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
//Generate a v4 (random) id
//uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'

class newToDo extends ConsumerStatefulWidget {
  const newToDo({super.key});
  @override
  ConsumerState<newToDo> createState() {
    return _newToDoState();
  }
}

class _newToDoState extends ConsumerState<newToDo> {
  final _titleController = TextEditingController();
  final _todoUUID = uuid.v4();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void saveToDo() {}

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return AlertDialog(
      title: const Text('New ToDo'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: const InputDecoration(labelText: 'todo title'),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                Navigator.of(context)
                    .pop(Todo(id: _todoUUID, title: _titleController.text));
              },
            ),
          ],
        )
      ],
    );
  }
}
