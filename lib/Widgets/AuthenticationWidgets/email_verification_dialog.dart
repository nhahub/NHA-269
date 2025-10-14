import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learnflow/Firebase/auth_service.dart';
import 'package:learnflow/Firebase/auth_wrapper.dart';
import 'package:learnflow/theme/app_colors.dart';

class EmailVerificationDialog extends StatefulWidget {
  final AuthService authService;
  const EmailVerificationDialog({super.key, required this.authService});

  @override
  State<EmailVerificationDialog> createState() =>
      _EmailVerificationDialogState();
}

class _EmailVerificationDialogState extends State<EmailVerificationDialog> {
  String? _message;
  Color _messageColor = AppColors.grey;
  bool _isResendDisabled = false;
  int _secondsRemaining = 0;
  Timer? _timer;

  void _setMessage(String text, Color color) {
    setState(() {
      _message = text;
      _messageColor = color;
    });
  }

  void _startCooldown([int seconds = 60]) {
    setState(() {
      _isResendDisabled = true;
      _secondsRemaining = seconds;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() {
          _isResendDisabled = false;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      title: const Text(
        'Verify Your Email',
        style: TextStyle(
          color: AppColors.deepSapphire,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'A verification link has been sent to your email address.\n\n'
              'Please verify your account before continuing.',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 15,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _messageColor.withAlpha((0.1 * 255).toInt()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _message!,
                      style: TextStyle(
                        color: _messageColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

            // Resend email section
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isResendDisabled)
                    Text(
                      '$_secondsRemaining s',
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  const SizedBox(width: 6),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: _isResendDisabled
                          ? AppColors.grey
                          : AppColors.oceanBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: _isResendDisabled
                        ? null
                        : () async {
                            try {
                              await widget.authService.sendEmailVerification();
                              _setMessage('Verification email sent again!',
                                  AppColors.teal);
                              _startCooldown();
                            } catch (e) {
                              final error = e.toString();
                              if (error.contains('too-many-requests')) {
                                _setMessage(
                                  'Too many requests. Try again later.',
                                  Colors.redAccent,
                                );
                                _startCooldown(120); // 2-minute cooldown
                              } else {
                                _setMessage(
                                  'Something went wrong. Please try again.',
                                  Colors.redAccent,
                                );
                              }
                            }
                          },
                    child: const Text('Resend Email'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Log Out button
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.oceanBlue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await widget.authService.signOut();
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Log Out'),
            ),

            // Check Again button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.oceanBlue,
                foregroundColor: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                await widget.authService.reloadUser();
                final user = widget.authService.currentUser;

                if (user != null && user.emailVerified) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const AuthWrapper()),
                    );
                  }
                } else {
                  _setMessage('Email still not verified.', AppColors.grey);
                }
              },
              child: const Text('Check Again'),
            ),
          ],
        ),
      ],
    );
  }
}
