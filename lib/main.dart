import 'package:flutter/material.dart';
import 'package:learnflow/screens/FocusScreen.dart';
import 'package:learnflow/screens/Material_Screen.dart';
import 'package:learnflow/screens/authentication_screen.dart';
import 'package:learnflow/screens/home_screen.dart';
import 'package:learnflow/screens/settings_screen.dart';
import 'package:learnflow/screens/timeTable_screen.dart';
import 'package:learnflow/screens/tasks_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthenticationScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/timetable': (context) => TimetableScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/Focus':(context)=>const FocusScreen(),
        '/Material':(context)=>const MaterialsScreen()
      },
    );
  }
}
