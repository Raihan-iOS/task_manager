// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/ui/screens/home/new_task_screen.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
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
                        taskCard(taskStatus: TaskStatus.Completed, taskModel: TaskModel(id: "id", title: "title", description: "description", status: "status", email: "email", createdDate: "createdDate"), refreashParents: (){},),
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
