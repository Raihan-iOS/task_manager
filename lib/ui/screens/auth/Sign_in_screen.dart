import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/screens/auth/forget_password_email_screen.dart';
import 'package:task_manager/ui/screens/auth/sign_up_screen.dart';
import 'package:task_manager/ui/screens/home/main_nav_holder_screen.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../widgets/SnackBarMessage.dart';
import '../Controller/login_provider.dart';

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
  final LoginProvider _logInProvider = LoginProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _logInProvider,
      child: Scaffold(
        body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Using a simple regex for email validation
                        if (EmailValidator.validate(value) == false) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(hintText: "Password"),
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    Consumer<LoginProvider>(
                      builder: (context,loginProvider,_) {
                        return Visibility(
                          visible: loginProvider.signInInProgress == false,
                          replacement: centered_circular_progress_indicator(),
                          child: FilledButton(
                            onPressed: () {
                              // if (_formKey.currentState!.validate()) {
                              _gotoHomepScreen();
                              // }
                            },
                            child: Icon(Icons.arrow_circle_right),
                          ),
                        );
                      }
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
    if (_formKey.currentState!.validate()) {
     //! Navigate to home screen
      debugPrint("Sign In Pressed after validation");
      _signIn();
    }
  }

  Future<void> _signIn() async {
    bool isSuccess = await _logInProvider.signIn(_emailController.text.trim(), _passwordController.text);
    if(isSuccess == true){
      _clearForm();
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainNavHolderScreen.routeName,
            (route) => false,
      );

    }else{
      _clearForm();
      ShowSnackBarMessage(context, _logInProvider.getErrorMessage!);
    }


  }

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
