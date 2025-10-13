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

  void _setMessage(String text, Color color) {
    setState(() {
      _message = text;
      _messageColor = color;
    });
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
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
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
                      color: _messageColor.withAlpha((0.1*255) as int),
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

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.oceanBlue,
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
                onPressed: () async {
                  await widget.authService.sendEmailVerification();
                  _setMessage('Verification email sent again!', AppColors.teal);
                },
                child: const Text('Resend Email'),
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
            // "Log Out" Button
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.oceanBlue,
                
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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

            // "Check Again" Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.oceanBlue,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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
                    setState(() {}); 
                    
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
