import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:task_manager/ui/screens/auth/Sign_in_screen.dart';
import 'package:task_manager/ui/screens/auth/forget_password_setpassword.dart';

import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../../data/services/api_caller.dart';
import '../../../data/utils/constant.dart';
import '../../widgets/SnackBarMessage.dart';

class ForgetPasswordOtp extends StatefulWidget {
  ForgetPasswordOtp({super.key,  this.emailAddress});
  static const String routeName = '/forget-password-otp';
  final String? emailAddress;

  @override
  State<ForgetPasswordOtp> createState() => _ForgetPasswordOtpState();
}

class _ForgetPasswordOtpState extends State<ForgetPasswordOtp> {
  final TextEditingController _pinController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _otpVerifyInProgress = false;


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final email = args?['email'] ?? widget.emailAddress ?? '';

    print('Received email: $email'); // Debug line
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
                  "PIN Verification",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "A 6 digit verification has been  sent to your email address",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                PinCodeTextField(
                  keyboardType: TextInputType.number,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    errorBorderColor: Colors.transparent,
                    activeColor: Colors.grey, // border when field has value
                    selectedColor:
                        Colors.green, // border when selected (focused)
                    inactiveColor: Colors.white, // border when inactive
                    // border when error
                    borderWidth: 1, // visible border
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,

                  controller: _pinController,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),
                const SizedBox(height: 24),
                Visibility(
                  visible: _otpVerifyInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: FilledButton(
                    onPressed: () {
                      _otpVerify(email);

                    },
                    child: const Text("Verify"),
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
  @override
  void dispose() {

    _pinController.dispose();
    super.dispose();

  }

  void _gotoSetPasswordScreen(BuildContext context) {
    Navigator.pushNamed(context, ForgetPasswordSetPassword.routeName,arguments: {'email': widget.emailAddress,'pin':_pinController.text.trim()});
  }

  void _otpVerify(String email) async {
    _otpVerifyInProgress = true;
    setState(() {});


    ApiResponse apiResponse = await ApiCaller.getRequest(url: Urls.verifyOtp(email,_pinController.text.trim()));
    if (apiResponse.isSuccess == true){
      _otpVerifyInProgress = false;
      setState(() {});
      _pinController.clear();
      _gotoSetPasswordScreen(context);
    }else{
      ShowSnackBarMessage(context, apiResponse.errorMessage ?? 'Something went wrong');
      _otpVerifyInProgress = false;
      _pinController.clear();
      setState(() {});
    }
  }
}
