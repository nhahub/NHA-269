import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:learnflow/Firebase/auth_service.dart';
import 'package:learnflow/Firebase/auth_wrapper.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _emailError;
  String? _passwordError;

  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  String _capitalizeFullName(String name) {
    return name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
        .join(' ');
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _emailError = null;
      _passwordError = null;
    });

    try {
      await AuthService().signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        displayName: _capitalizeFullName(_nameController.text.trim()),
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
        );
      }
    } catch (e) {
      final errorMessage = e.toString();
      setState(() {
        if (errorMessage.contains('already registered') ||
            errorMessage.contains('already in use')) {
          _emailError = 'This email is already registered.';
        } else if (errorMessage.contains('weak-password')) {
          _passwordError = 'Password is too weak.';
        } else {
          _emailError = 'Check your email or password and try again.';
        }
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
          buildTextField(
            'Full Name',
            Icons.person,
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          buildTextField(
            'Email Address',
            Icons.email,
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!_emailRegex.hasMatch(value.trim())) {
                return 'Enter a valid email address';
              }
              return null;
            },
            errorText: _emailError,
          ),
          const SizedBox(height: 16),
          buildTextField(
            'Password',
            Icons.lock,
            obscure: true,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              List<String> errors = [];
              if (value.length < 6) {
                errors.add('• At least 6 characters');
              }
              if (!RegExp(r'[0-9]').hasMatch(value)) {
                errors.add('• At least one number');
              }
              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                errors.add('• At least one special character');
              }
              if (errors.isNotEmpty) {
                return 'Password must include:\n${errors.join('\n')}';
              }
              return null;
            },
            errorText: _passwordError,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: _loading ? 'Creating...' : 'Create Account',
            onPressed: _loading ? null : _register,
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
      ),
    );
  }
}
