import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:learnflow/Firebase//auth_service.dart';
import '../../Widgets/Shared/custom_button.dart';
import '../../Widgets/Shared/text_field.dart';
import '../../theme/app_colors.dart';

class SignUpForm extends StatefulWidget {
  final VoidCallback onToggle;
  const SignUpForm({super.key, required this.onToggle});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _register() async {
    setState(() => _loading = true);
    try {
      await AuthService().signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        displayName: _nameController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

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

        buildTextField('Full Name', Icons.person, controller: _nameController),
        const SizedBox(height: 16),
        buildTextField('Email Address', Icons.email, controller: _emailController),
        const SizedBox(height: 16),
        buildTextField('Password', Icons.lock, obscure: true, controller: _passwordController),
        const SizedBox(height: 24),

        CustomButton(
          text: _loading ? 'Creating...' : 'Create Account',
          onPressed: _register,
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
                  recognizer: TapGestureRecognizer()..onTap = widget.onToggle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
