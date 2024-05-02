import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<StatefulWidget> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  String _choice = "false";

  Future<void> _pickImageSource() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profile Picture'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('please choose where your picture is coming from.'),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  child: const Text('Camera'),
                  onPressed: () {
                    _choice = "camera";
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Gallery'),
                  onPressed: () {
                    _choice = "gallery";
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _pickImage() async {
    await _pickImageSource();
    var pickedImage;
    print(_choice);

    if (_choice == 'camera') {
      pickedImage = await ImagePicker().pickImage(
          source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    } else {
      pickedImage = await ImagePicker().pickImage(
          source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    }

    setState(() {
      if (pickedImage == null) return;
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: () {
            _pickImage();
          },
          icon: Icon(Icons.image),
          label: Text(
            'add image',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        )
      ],
    );
  }
}
