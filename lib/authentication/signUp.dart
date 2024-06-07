import 'package:flutter/material.dart';
import 'dart:io';
import 'package:productivity_app/widgets/image_upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // in the firestore there is data NOT files
import 'package:firebase_storage/firebase_storage.dart'; // sending files to firebase, pat of the sdk
import 'dart:math';

final _firebase = FirebaseAuth.instance; // this also in login sau in welcome

class signUpScreen extends StatefulWidget {
  signUpScreen({super.key});

  @override
  State<signUpScreen> createState() {
    return _signUpScreenState();
  }
}

class _signUpScreenState extends State<signUpScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredPassword = "";
  var _enteredEmail = "";
  var _enteredUsername = "";
  var _enteredFirstName = "";
  var _enteredLastName = "";
  var _isAuthenticating = false;
  File? _selectedImage;

  void _submit() async {
    var rng = Random().nextInt(237) + 1;
    String imageUrl = "https://placedog.net/800/640?id=${rng}";

    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);
      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref() // just a reference to our firebase storage so that we can modify it
            .child('user_images') // to create a new path in the folder
            .child('${userCredentials.user!.uid}.jpg');
        await storageRef
            .putFile(_selectedImage!); // to put the file to that path
        imageUrl = await storageRef
            .getDownloadURL(); // we need this so that later we can actually use and display that image and that s why we put it later in image_url
      }
      // we need this so that later we can actually use and display that image and that s why we put it later in image_url
      await FirebaseFirestore.instance
          .collection(
              "users") // folders that contains data, create a new collection named users if it doesn t exist
          .doc(
              '${userCredentials.user!.uid}') // collections can have ore nested collections but here we have only a root collections with data entreis for each user
          .set({
        'username': _enteredUsername,
        'email': _enteredEmail,
        'lastName': _enteredLastName,
        'firstName': _enteredFirstName,
        'image_url': imageUrl,
      });

      await FirebaseFirestore.instance
          .collection("users")
          .doc('${userCredentials.user!.uid}')
          .collection("SOCIAL")
          .doc("manageFriends")
          .set({'friends': [], 'sent_requests': [], 'incoming_requests': []});
      await FirebaseFirestore.instance
          .collection("users")
          .doc('${userCredentials.user!.uid}')
          .collection("SOCIAL")
          .doc("groups")
          .set({'inGroups': []});
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        //.....
      }
      print(error.code);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'authentication failed'),
        ),
      );
    }
    setState(() {
      _isAuthenticating = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                )),
            Card(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UserImagePicker(onPickImage: (pickedImage) {
                          _selectedImage = pickedImage;
                        }),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'email address'),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains("@")) {
                              return 'please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'first name'),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'please enter a valid name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredFirstName = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'last name'),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'please enter a valid name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredLastName = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'username'),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'please enter a valid username';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredUsername = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'please enter a 6 char long passs';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                        const SizedBox(height: 12),
                        if (_isAuthenticating) CircularProgressIndicator(),
                        if (!_isAuthenticating)
                          ElevatedButton(
                            onPressed: () {
                              _submit();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            child: Text("Continue"),
                          ),
                        if (!_isAuthenticating)
                          TextButton(
                            onPressed: () {
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel"),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
