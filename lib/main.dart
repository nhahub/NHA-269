import 'package:flutter/material.dart';
import 'package:learnflow/screens/home_page.dart';
import 'package:learnflow/screens/sign_in.dart';
import 'package:learnflow/screens/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: SignIn()),
      debugShowCheckedModeBanner: false,
      routes: {
        '/signUp': (context) => const SignUp(),
        '/signIn': (context) => const SignIn(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
