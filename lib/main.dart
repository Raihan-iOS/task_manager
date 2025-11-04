import 'package:flutter/material.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/ui/screens/Controller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthController.getUserData();
  runApp(TaskMangerApp());
}
