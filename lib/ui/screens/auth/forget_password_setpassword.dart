import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:task_manager/ui/screens/auth/Sign_in_screen.dart';

import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../../data/services/api_caller.dart';
import '../../../data/utils/constant.dart';
import '../../widgets/SnackBarMessage.dart';

class ForgetPasswordSetPassword extends StatefulWidget {
  ForgetPasswordSetPassword({super.key, this.emailAddress, this.pin});
  static const String routeName = '/forget-password-setpassword';
  final String? emailAddress;
  final String? pin;


  @override
  State<ForgetPasswordSetPassword> createState() => _ForgetPasswordSetPasswordState();
}

class _ForgetPasswordSetPasswordState extends State<ForgetPasswordSetPassword> {
  final TextEditingController _paswordController = TextEditingController();

  final TextEditingController _confirmPaswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _setpasswordInProgress = false;

  @override
  Widget build(BuildContext context) {


    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final email = args?['email'] ??  widget.emailAddress ?? '';
    final pin = args?['pin'] ??  widget.pin ?? '';
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
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
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Password"),
                    controller: _paswordController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter password';
                      }
                      if (value!.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Confirm Password",
                    ),
                    controller: _confirmPaswordController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter confirm password';
                      }
                      if (value != _paswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Visibility(
                    visible: _setpasswordInProgress == false,
                    child: FilledButton(

                      onPressed: () {
                        _setPassword(email, pin);
                      },
                      child: Icon(Icons.arrow_circle_right),
                    ),
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
      ),
    );
  }
  @override
  void dispose() {
    _confirmPaswordController.dispose();
    _paswordController.dispose();
    super.dispose();
  }

  Future<void> _setPassword(String email,String pin) async {
    _setpasswordInProgress = true;
    debugPrint('Email: $email, PIN: $pin');
    debugPrint('password: $_paswordController.text.trim()');

    Map<String,dynamic> requestBody = {
      "email":email,
      "OTP": pin,
      "password":_paswordController.text.trim()
    };
    ApiResponse apiResponse = await ApiCaller.postRequest(url: Urls.setPassword,body:requestBody);
    if (apiResponse.isSuccess == true){
      ShowSnackBarMessage(context, 'Password reset successfully');
      _setpasswordInProgress = false;
      setState(() {});
      _gotoSignInScreen(context);

    }else{
      ShowSnackBarMessage(context, apiResponse.errorMessage ?? 'Something went wrong');
      _setpasswordInProgress = false;
      setState(() {});
    }
  }

  void _gotoSignInScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.routeName,
      (route) => false,
    );
  }
}
