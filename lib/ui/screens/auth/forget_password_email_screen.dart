import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/auth/Sign_in_screen.dart';
import 'package:task_manager/ui/screens/auth/forget_password_otp.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class ForgetPasswordEmail extends StatelessWidget {
  ForgetPasswordEmail({super.key});

  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 82),
                Text(
                  "Your Email Address",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "A 6 digit verification code will be sent to your email address",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Email"),
                  controller: _emailController,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    _gotoPinScreen(context);
                  },
                  child: const Icon(Icons.arrow_circle_right),
                ),
                const SizedBox(height: 36),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      text: "Already have an account? ",
                      children: [
                        TextSpan(
                          text: "Sign In",
                          style: const TextStyle(color: Colors.green),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  _gotoSignInScreen(context);
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _gotoSignInScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => SignInScreen()),
      (route) => false,
    );
  }

  void _gotoPinScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgetPasswordOtp()),
    );
  }
}
