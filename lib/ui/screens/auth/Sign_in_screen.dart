import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/auth/forget_password_email_screen.dart';
import 'package:task_manager/ui/screens/auth/sign_up_screen.dart';
import 'package:task_manager/ui/screens/home/main_nav_holder_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const String routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 82),
                  Text(
                    "Get Started With",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 24),

                  TextFormField(
                    decoration: InputDecoration(hintText: "Email"),
                    controller: _emailController,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Password"),
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      _gotoHomepScreen();
                      // }
                    },
                    child: Icon(Icons.arrow_circle_right),
                  ),
                  SizedBox(height: 36),
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            _gotoEmailPasswordScreen();
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            text: "Don't have an account? ",
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(color: Colors.green),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        _gotoSignUpScreen();
                                      },
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
      ),
    );
  }

  void _gotoSignUpScreen() {
    Navigator.pushNamed(context, SignUpScreen.routeName);
  }

  void _gotoEmailPasswordScreen() {
    Navigator.pushNamed(context, ForgetPasswordEmail.routeName);
  }

  void _gotoHomepScreen() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      MainNavHolderScreen.routeName,
      (route) => false,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
