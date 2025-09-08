import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/Sign_in_screen.dart';
import 'package:task_manager/ui/screens/forget_password_otp.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class ForgetPasswordSetPassword extends StatelessWidget {
  ForgetPasswordSetPassword({super.key});

  final TextEditingController _paswordController = TextEditingController();
  final TextEditingController _confirmPaswordController = TextEditingController();
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
                  "Set Password",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "Password must be at least 8 characters and include 1 letter, 1 number & 1 special character",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Password"),
                  controller: _paswordController,
                ),
                 const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Confirm Password"),
                  controller: _paswordController,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: (){
                    _gotoSignInScreen(context);
                  },
                  child: Icon(Icons.arrow_circle_right),
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
                          recognizer: TapGestureRecognizer()
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

}
