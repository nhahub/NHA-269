import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learnflow/Firebase/auth_wrapper.dart';
import 'firebase_options.dart';
import 'package:learnflow/screens/Focus_Screen.dart';
import 'package:learnflow/screens/Material_Screen.dart';
import 'package:learnflow/screens/authentication_screen.dart';
import 'package:learnflow/screens/home_screen.dart';
import 'package:learnflow/screens/settings_screen.dart';
import 'package:learnflow/screens/timeTable_screen.dart';
import 'package:learnflow/screens/tasks_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/auth': (context) => const AuthenticationScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/timetable': (context) => TimetableScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/Focus': (context) => const FocusScreen(),
        '/Material': (context) => const MaterialsScreen(),
      },
    );
  }
}
