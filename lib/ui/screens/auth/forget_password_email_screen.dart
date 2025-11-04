import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/auth/Sign_in_screen.dart';
import 'package:task_manager/ui/screens/auth/forget_password_otp.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../../data/services/api_caller.dart';
import '../../../data/utils/constant.dart';
import '../../widgets/SnackBarMessage.dart';


class ForgetPasswordEmail extends StatefulWidget {
  ForgetPasswordEmail({super.key});

  static const String routeName = '/forget-password';

  @override
  State<ForgetPasswordEmail> createState() => _ForgetPasswordEmailState();
}

class _ForgetPasswordEmailState extends State<ForgetPasswordEmail> {
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _otpSendInProgress = false;

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
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "A 6 digit verification code will be sent to your email address",
                  style: Theme
                      .of(
                    context,
                  )
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Email"),
                  controller: _emailController,
                ),
                const SizedBox(height: 24),
                Visibility(
                  visible: _otpSendInProgress == false,
                  replacement: Center(child: CircularProgressIndicator()),
                  child: FilledButton(
                    onPressed: () {
                      _sendOtpToEmail();
                    },
                    child: const Icon(Icons.arrow_circle_right),
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
    );
  }

  void _gotoSignInScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.routeName,
          (route) => false,
    );
  }

  void _gotoPinScreen(BuildContext context,String email) {
    Navigator.pushNamed(context, ForgetPasswordOtp.routeName,arguments:{'email': email}, );
  }

  void _sendOtpToEmail() async {
    _otpSendInProgress = true;
    setState(() {});


    ApiResponse apiResponse = await ApiCaller.getRequest(url: Urls.verifyEmail(_emailController.text.trim()));
    if (apiResponse.isSuccess == true){
      _otpSendInProgress = false;
      setState(() {});
      _gotoPinScreen(context,_emailController.text.trim());
    }else{
      ShowSnackBarMessage(context, apiResponse.errorMessage ?? 'Something went wrong');
      _otpSendInProgress = false;
      setState(() {});
    }
  }
}

