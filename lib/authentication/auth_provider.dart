import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:productivity_app/authentication/welcome.dart';
import 'package:productivity_app/widgets/tabs.dart';

// Define a provider for authentication state
final authProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Define a state notifier to manage user-specific data
class UserDataNotifier extends StateNotifier<Map<String, dynamic>?> {
  UserDataNotifier() : super(null);

  void setUserData(Map<String, dynamic>? userData) {
    state = userData;
  }

  void clearUserData() {
    state = null;
  }
}

// Define a provider for the state notifier
final userDataProvider =
    StateNotifierProvider<UserDataNotifier, Map<String, dynamic>?>((ref) {
  return UserDataNotifier();
});

class AuthenticationWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userDataNotifier = ref.read(userDataProvider.notifier);

    return authState.when(
      data: (user) {
        if (user != null) {
          // Fetch user data when a user is logged in
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get()
              .then((doc) {
            userDataNotifier.setUserData(doc.data());
          });
          return TabsScreen();
        } else {
          // Clear user data when no user is logged in
          userDataNotifier.clearUserData();
          return WelcomeScreen();
        }
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
