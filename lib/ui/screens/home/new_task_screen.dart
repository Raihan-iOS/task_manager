import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/home/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/task_card.dart';
import 'package:task_manager/ui/widgets/task_count_by_status_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 16),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder:
                    (context, index) =>
                        TaskCountByStatus(title: 'New', count: 2),
                separatorBuilder: (context, index) => const SizedBox(width: 4),
                itemCount: 4,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemBuilder:
                    (context, index) => taskCard(taskStatus: TaskStatus.New),
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemCount: 10,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => gotoAddNewtaskScreen(),
        child: Icon(Icons.add),
      ),
    );
  }

  void gotoAddNewtaskScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewTaskScreen()),
    );
  }
}

enum TaskStatus { New, Progress, Canceled, Completed }
