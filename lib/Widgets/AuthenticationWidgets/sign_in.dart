import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../Widgets/Shared/custom_button.dart';
import '../../Widgets/Shared/text_field.dart';
import '../../theme/app_colors.dart';

class SignInForm extends StatelessWidget {
  final VoidCallback onToggle;
  const SignInForm({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('signInForm'),
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
          child: GestureDetector(
            onTap: () {},
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
          child: Text.rich(
            TextSpan(
              text: "Don't have an account? ",
              style: const TextStyle(color: AppColors.grey, fontSize: 14),
              children: [
                TextSpan(
                  text: 'Sign up',
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
