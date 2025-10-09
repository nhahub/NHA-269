import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:learnflow/screens/sign_up.dart';
import '../Widgets/Shared/custom_button.dart';
import '../Widgets/Shared/text_field.dart';
import '../theme/app_colors.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.oceanBlue, AppColors.teal],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: AppColors.white,
                  size: 56,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'StudyPal',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your personal academic assistant',
                style: TextStyle(color: AppColors.white, fontSize: 14),
              ),
              const SizedBox(height: 60),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: AppColors.deepSapphire,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sign in to continue',
                      style: TextStyle(color: AppColors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    buildTextField('Email Address', Icons.email),
                    const SizedBox(height: 16),
                    buildTextField('Password', Icons.lock, obscure: true),
                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.oceanBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    CustomButton(
                      text: 'Sign In',
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                    ),
                    const SizedBox(height: 12),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style: const TextStyle(
                                color: AppColors.oceanBlue,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUp(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
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
