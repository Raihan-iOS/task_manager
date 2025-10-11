import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager/ui/screens/Controller/auth_controller.dart';
import 'package:task_manager/ui/screens/auth/Sign_in_screen.dart';
import 'package:task_manager/ui/screens/home/main_nav_holder_screen.dart';
import 'package:task_manager/ui/utils/assets_path.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    bool isLoggedIn = await AuthController.isUserAlreadyLoggedIn();
    if (isLoggedIn == true){
     await AuthController.getUserData();
    Navigator.pushReplacementNamed(context, MainNavHolderScreen.routeName);
    }else{
    Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScreenBackground(
          child: Center(
            child: SvgPicture.asset(AssetsPaths.logo, width: 60, height: 60),
          ),
        ),
      ),
    );
  }
}
