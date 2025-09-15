import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/home/canceled_task_screen.dart';
import 'package:task_manager/ui/screens/home/completed_task_screen.dart';
import 'package:task_manager/ui/screens/home/new_task_screen.dart';
import 'package:task_manager/ui/screens/home/progress_task_screen.dart';
import 'package:task_manager/ui/widgets/app_bar.dart';

class MainNavHolderScreen extends StatefulWidget {
  const MainNavHolderScreen({super.key});

  @override
  State<MainNavHolderScreen> createState() => _MainNavHolderScreenState();
}

class _MainNavHolderScreenState extends State<MainNavHolderScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    NewTaskScreen(),
    ProgressTaskScreen(),
    CanceledTaskScreen(),
    CompletedTaskScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppbar(),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.new_label_outlined),
            label: "New",
          ),
          NavigationDestination(
            icon: Icon(Icons.change_circle_outlined),
            label: "Progress",
          ),
          NavigationDestination(
            icon: Icon(Icons.cancel_outlined),
            label: "Canceled",
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            label: "Completed",
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: Center(child: _screens[_selectedIndex]),
    );
  }
}
