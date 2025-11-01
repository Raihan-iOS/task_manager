import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/constant.dart';
import 'package:task_manager/ui/screens/Controller/new_task_list_provider.dart';
import 'package:task_manager/ui/screens/Controller/task_count_provider.dart';
import 'package:task_manager/ui/screens/home/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/SnackBarMessage.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/task_card.dart';
import 'package:task_manager/ui/widgets/task_count_by_status_card.dart';

import '../../../data/models/task_status_count_model.dart';
import '../Controller/auth_controller.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});
  static const String routeName = '/new-tasks';

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllTaskStatusCount();
      _getAllNewTasks();
    });
  }

  //! Task Count By Status
  Future<void> _getAllTaskStatusCount() async {
    final taskCountProvider = context.read<TaskCountProvider>();
    bool isSuccess = await taskCountProvider.getTaskCount();
    if (!isSuccess && mounted) {
      ShowSnackBarMessage(context, taskCountProvider.getErrorMessage!);
    }
  }

  //! Get task Data
  Future<void> _getAllNewTasks() async {
    final newTaskListProvider = context.read<NewTaskListProvider>();
    bool isSuccess = await newTaskListProvider.newTaskListFetch();
    if (!isSuccess && mounted) {
      ShowSnackBarMessage(context, newTaskListProvider.getErrorMessage!);
    }
  }

  //! Refresh data when screen comes into view
  Future<void> _refreshData() async {
    await Future.wait([
      _getAllTaskStatusCount(),
      _getAllNewTasks(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: 16),
              SizedBox(
                height: 90,
                child: Consumer<TaskCountProvider>(
                  builder: (context, taskCountController, _) {
                    return Visibility(
                      visible: taskCountController.taskCountInProgress == false,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: taskCountController.taskStatusCountList.isEmpty
                          ? Center(child: Text('No status data'))
                          : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => TaskCountByStatus(
                          title: taskCountController.taskStatusCountList[index].status,
                          count: taskCountController.taskStatusCountList[index].count,
                        ),
                        separatorBuilder: (context, index) => const SizedBox(width: 4),
                        itemCount: taskCountController.taskStatusCountList.length,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Consumer<NewTaskListProvider>(
                  builder: (context, controller, _) {
                    return Visibility(
                      visible: controller.newTaskListInProgress == false,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: controller.newTaskList.isEmpty
                          ? Center(child: Text('No tasks available'))
                          : ListView.separated(
                        itemBuilder: (context, index) => taskCard(
                          taskStatus: TaskStatus.New,
                          taskModel: controller.newTaskList[index],
                          refreashParents: () {
                            controller.newTaskListFetch();
                            _getAllTaskStatusCount();
                          },
                        ),
                        separatorBuilder: (context, index) => const SizedBox(height: 4),
                        itemCount: controller.newTaskList.length,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AddNewTaskScreen.routeName),
        child: Icon(Icons.add),
      ),
    );
  }
}

enum TaskStatus { New, Progress, Canceled, Completed }