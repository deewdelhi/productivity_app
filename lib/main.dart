import 'package:flutter/material.dart';
import 'package:productivity_app/TODO/all_todo_lists.dart';
import 'package:productivity_app/authentication/auth_provider.dart';
import 'package:productivity_app/authentication/logIn.dart';
import 'package:productivity_app/authentication/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:productivity_app/widgets/tabs.dart';
import 'firebase_options.dart';
import 'package:productivity_app/authentication/splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_app/providers/user_provider.dart';

final userDataProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Calendar App',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 45, 94, 4)),
        useMaterial3: true,
      ),
      home:
          //AuthenticationWrapper()
          StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (snapshot.hasData) {
            return TabsScreen();
          }
          return WelcomeScreen();
        },
      ),
    );
  }
}
