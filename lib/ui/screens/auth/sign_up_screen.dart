
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/constant.dart';
import 'package:task_manager/ui/widgets/SnackBarMessage.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../widgets/centered_progress_indicator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String routeName = '/sign-up';

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
  bool _signUpInProgress = false;
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
                    "Join With Us",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 24),

                  TextFormField(
                    decoration: InputDecoration(hintText: "Email"),
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
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
                    decoration: InputDecoration(hintText: "First Name"),
                    textInputAction: TextInputAction.next,
                    controller: _firstNameController,
                    validator: (value) {
                      if (value?.trim() == null ||
                          value?.trim().isEmpty == true) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Last Name"),
                    textInputAction: TextInputAction.next,
                    controller: _lastNameController,
                    validator: (value) {
                      if (value?.trim() == null ||
                          value?.trim().isEmpty == true) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Mobile No"),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    controller: _mobileNoController,
                    validator: (value) {
                      if (value?.length == 0) {
                        return 'Please enter your mobile no';
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
                    visible: _signUpInProgress == false,
                    replacement: centered_circular_progress_indicator(),
                    child: FilledButton(
                      onPressed: () {
                        debugPrint("Sign Up Pressed");
                        if (_formKey.currentState!.validate()) {
                          debugPrint("Sign Up Pressed after validation");
                          _onTapSubmit();
                        }
                      },
                      child: Icon(Icons.arrow_circle_right),
                    ),
                  ),
                  SizedBox(height: 36),
                  Center(
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
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
      ),
    );
  }

  void _gotoSignInScreen() {
    Navigator.pop(context);
  }

  void _onTapSubmit() {
    _signUp();
  }

  Future<void> _signUp() async {
    _signUpInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileNoController.text.trim(),
    };
    ApiResponse response = await ApiCaller.postRequest(
      url: Urls.registration,
      body: requestBody,
    );
    if (response.isSuccess == true) {
      ShowSnackBarMessage(context, 'Resgistration Successful,Now Login.');
      _clearForm();
      _signUpInProgress = false;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        ShowSnackBarMessage(
          context,
          response.errorMessage ?? 'An error occurred',
        ),
      );
      _signUpInProgress = false;
      setState(() {});
    }
  }

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _mobileNoController.clear();
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

