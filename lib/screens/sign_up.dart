import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:learnflow/screens/sign_in.dart';
import '../textField_widget/custom_button.dart';
import '../textField_widget/text_field.dart';
import '../theme/app_colors.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

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
                  color: AppColors.white.withOpacity(0.15),
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
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Get Started',
                      style: TextStyle(
                        color: AppColors.deepSapphire,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Create your account to begin',
                      style: TextStyle(color: AppColors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    buildTextField('Full Name', Icons.person),
                    const SizedBox(height: 16),
                    buildTextField('Email Address', Icons.email),
                    const SizedBox(height: 16),
                    buildTextField('Password', Icons.lock, obscure: true),
                    const SizedBox(height: 24),

                    CustomButton(
                      text: 'Create Account',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: () {},
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'Already have an account? ',
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign in',
                                style: const TextStyle(
                                  color: AppColors.oceanBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SignIn(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
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
