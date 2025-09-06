import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';

class TaskMangerApp extends StatelessWidget {
  const TaskMangerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen());
  }
}
