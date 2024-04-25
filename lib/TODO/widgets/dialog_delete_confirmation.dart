import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Function onConfirm;
  String message;
  DeleteConfirmationDialog({required this.onConfirm, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Confirmation'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onConfirm(); // Call the provided function to confirm deletion
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}
