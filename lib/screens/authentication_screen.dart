import 'package:flutter/material.dart';
import 'package:learnflow/Widgets/AuthenticationWidgets/sign_in.dart';
import 'package:learnflow/Widgets/AuthenticationWidgets/sign_up.dart';
import 'package:learnflow/Widgets/AuthenticationWidgets/social_button.dart';
import '../theme/app_colors.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool showSignUp = false;

  void toggleAuthMode() => setState(() => showSignUp = !showSignUp);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.oceanBlue, AppColors.teal],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/icon/app_icon.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // App Name & Tagline
              const Text(
                'LearnFlow',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your personal academic assistant',
                style: TextStyle(color: AppColors.white, fontSize: 14),
              ),
              const SizedBox(height: 40),

              // Auth Form
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    showSignUp
                        ? SignUpForm(onToggle: toggleAuthMode)
                        : SignInForm(onToggle: toggleAuthMode),
                    const SizedBox(height: 20),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.grey.withValues(alpha: 0.5),
                            thickness: 0.6,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Or Sign in with',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.grey.withValues(alpha: 0.5),
                            thickness: 0.6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Social Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SocialButton(
                          icon: 'assets/icons/google.png',
                          label: 'Google',
                          onTap: () {
                            // Google sign-in logic
                          },
                        ),
                        SocialButton(
                          icon: 'assets/icons/microsoft.png',
                          label: 'Microsoft',
                          onTap: () {
                            // Microsoft sign-in logic
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
