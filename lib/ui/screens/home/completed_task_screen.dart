// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/ui/screens/home/new_task_screen.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

import '../../../data/services/api_caller.dart';
import '../../../data/utils/constant.dart';
import '../../widgets/SnackBarMessage.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {


  bool _getCompletedTaskInProgress = false;
  List<TaskModel> _completedTaskList = [];

  initState() {
    super.initState();
    _getAllCompletedTasks();
  }
  //! Get cancelled  task Data

  Future<void> _getAllCompletedTasks() async {
    _getCompletedTaskInProgress = true;
    setState(() {});

    ApiResponse apiResponse = await ApiCaller.getRequest(url: Urls.completedTasks);

    if (apiResponse.isSuccess == true) {
      List<TaskModel> list = [];

      // FIX: Ensure data is a List
      var data = apiResponse.responseData['data'];
      if (data is List) {
        for (var task in data) {
          if (task is Map<String, dynamic>) {
            list.add(TaskModel.fromJson(task));
          }
        }
      }
      _completedTaskList = list;
      _getCompletedTaskInProgress = false;
      setState(() {});
    } else {
      ShowSnackBarMessage(context, apiResponse.errorMessage!);
      _getCompletedTaskInProgress = false;
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: Visibility(
                visible: _getCompletedTaskInProgress == false,
                replacement: const Center(child: CircularProgressIndicator()),
                child: ListView.separated(
                  itemBuilder:
                      (context, index) =>
                          taskCard(taskStatus: TaskStatus.Completed, taskModel:_completedTaskList[index], refreashParents: (){
                            _getAllCompletedTasks();
                          },),
                  separatorBuilder: (context, index) => const SizedBox(height: 4),
                  itemCount: _completedTaskList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
