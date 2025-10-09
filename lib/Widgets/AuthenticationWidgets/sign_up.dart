import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../Widgets/Shared/custom_button.dart';
import '../../Widgets/Shared/text_field.dart';
import '../../theme/app_colors.dart';

class SignUpForm extends StatelessWidget {
  final VoidCallback onToggle;
  const SignUpForm({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('signUpForm'),
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
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        const SizedBox(height: 12),

        Center(
          child: Text.rich(
            TextSpan(
              text: 'Already have an account? ',
              style: const TextStyle(color: AppColors.grey, fontSize: 14),
              children: [
                TextSpan(
                  text: 'Sign in',
                  style: const TextStyle(
                    color: AppColors.oceanBlue,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onToggle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
