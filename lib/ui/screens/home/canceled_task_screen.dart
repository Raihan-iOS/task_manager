// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/home/new_task_screen.dart';
import 'package:task_manager/ui/widgets/task_card.dart';
import 'package:task_manager/ui/widgets/task_count_by_status_card.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemBuilder:
                    (context, index) =>
                        taskCard(taskStatus: TaskStatus.Canceled),
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
