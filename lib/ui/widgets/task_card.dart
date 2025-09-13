import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/home/new_task_screen.dart';

class taskCard extends StatelessWidget {
  const taskCard({super.key, required this.taskStatus});
  final TaskStatus taskStatus;

  Color TaskTypeColor(TaskStatus taskType) {
    if (taskType == TaskStatus.New) {
      return Colors.blue;
    } else if (taskType == TaskStatus.Progress) {
      return Colors.purple;
    } else if (taskType == TaskStatus.Completed) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Colors.white,
      title: Text('Task name will be given'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text('Description Project name will be given'),
          Text(
            'Date 12/12/2021',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              Chip(
                label: Text(
                  taskStatus.name,
                  style: TextStyle(color: Colors.white),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                backgroundColor: TaskTypeColor(taskStatus),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete, color: Colors.red),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.edit, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
