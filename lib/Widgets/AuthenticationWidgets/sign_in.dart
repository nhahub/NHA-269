import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:learnflow/Firebase/auth_service.dart';
import '../../Widgets/Shared/custom_button.dart';
import '../../Widgets/Shared/text_field.dart';
import '../../theme/app_colors.dart';

class SignInForm extends StatefulWidget {
  final VoidCallback onToggle;
  const SignInForm({super.key, required this.onToggle});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String? _errorText;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      await AuthService().signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      
      setState(() {
        _errorText = 'Check either email or password is incorrect';
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

          buildTextField(
            'Email Address',
            Icons.email,
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Enter a valid email';
              }
              return null;
            },
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
              return null;
            },
            errorText: _errorText, 
          ),
          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // TODO: Add reset password navigation
              },
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
            text: _loading ? 'Signing In...' : 'Sign In',
            onPressed: _loading ? null : _login,
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
