import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/constant.dart';
import 'package:task_manager/ui/screens/Controller/auth_controller.dart';
import 'package:task_manager/ui/screens/auth/forget_password_email_screen.dart';
import 'package:task_manager/ui/screens/auth/sign_up_screen.dart';
import 'package:task_manager/ui/screens/home/main_nav_holder_screen.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../widgets/SnackBarMessage.dart';

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
  bool _signInInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Visibility(
                    visible: _signInInProgress == false,
                    replacement: centered_circular_progress_indicator(),
                    child: FilledButton(
                      onPressed: () {
                        // if (_formKey.currentState!.validate()) {
                        _gotoHomepScreen();
                        // }
                      },
                      child: Icon(Icons.arrow_circle_right),
                    ),
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
    if (_formKey.currentState!.validate()) {
     //! Navigate to home screen
      debugPrint("Sign In Pressed after validation");
      _signIn();
    }
  }

  void _signIn() async {
    _signInInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
    };
    ApiResponse response =
        await ApiCaller.postRequest(url: Urls.login, body: requestBody);
    debugPrint('Response: ${response.responseData}');
    debugPrint('Status: ${response.responseData['status']}');

    if (response.isSuccess == true && response.responseData['status'] == 'success') {
      UserModel userModel = UserModel.fromJson(response.responseData['data']);
      String accessToken  = response.responseData['token'];
      await AuthController.saveUserData(userModel, accessToken);

      debugPrint('User from AuthController: ${AuthController.userModel}');
      debugPrint('Token from AuthController: ${AuthController.accessToken}');
      debugPrint('Token saved: ${AuthController.accessToken}');


      _clearForm();
      _signInInProgress = false;
      setState(() {});
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainNavHolderScreen.routeName,
        (route) => false,
      );
    } else {
      _signInInProgress = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        ShowSnackBarMessage(
          context,
          response.errorMessage ?? 'An error occurred',
        ),
      );
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
