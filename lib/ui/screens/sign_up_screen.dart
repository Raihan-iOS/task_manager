import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/Sign_up_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();

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
                SizedBox(height: 82),
                Text(
                  "Join With Us",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 24),

                TextFormField(
                  decoration: InputDecoration(hintText: "Email"),
                  controller: _emailController,
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(hintText: "First Name"),
                  controller: _firstNameController,
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(hintText: "Last Name"),
                  controller: _lastNameController,
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(hintText: "Mobile No"),
                  controller: _mobileNoController,
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(hintText: "Password"),
                  controller: _passwordController,
                  obscureText: true,
                ),
                SizedBox(height: 24),
                FilledButton(
                  onPressed: () {},
                  child: Icon(Icons.arrow_circle_right),
                ),
                SizedBox(height: 36),
                Center(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          text: "Already have an account? ",
                          children: [
                            TextSpan(
                              text: "Sign in",
                              style: TextStyle(color: Colors.green),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = _gotoSignInScreen,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _gotoSignInScreen() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileNoController.dispose();
    super.dispose();
  }
}
