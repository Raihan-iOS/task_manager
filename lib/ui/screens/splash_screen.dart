import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager/ui/utils/assets_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            AssetsPaths.screenBack,
            width: double.infinity,
            height: double.infinity,
          ),
        ],
      ),
    );
  }
}
