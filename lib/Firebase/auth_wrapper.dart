import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnflow/Firebase/auth_service.dart';
import 'package:learnflow/screens/authentication_screen.dart';
import 'package:learnflow/screens/home_screen.dart';
import 'package:learnflow/Widgets/AuthenticationWidgets/email_verification_dialog.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: FirebaseAuth.instance.idTokenChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user != null) {
          if (!user.emailVerified) {
            
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => EmailVerificationDialog(authService: authService),
              );
            });
          }
          return const HomeScreen();
        }

        return const AuthenticationScreen();
      },
    );
  }
}
