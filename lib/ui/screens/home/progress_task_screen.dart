// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/ui/screens/home/new_task_screen.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

import '../../../data/services/api_caller.dart';
import '../../../data/utils/constant.dart';
import '../../widgets/SnackBarMessage.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  bool _getProgressTaskInProgress = false;
  List<TaskModel> _progressTaskList = [];

  initState() {
    super.initState();
    _getAllProgressTasks();
  }
  //! Get cancelled  task Data

  Future<void> _getAllProgressTasks() async {
    _getProgressTaskInProgress = true;
    setState(() {});

    ApiResponse apiResponse = await ApiCaller.getRequest(url: Urls.progressTasks);

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
      _progressTaskList = list;
      _getProgressTaskInProgress = false;
      setState(() {});
    } else {
      ShowSnackBarMessage(context, apiResponse.errorMessage!);
      _getProgressTaskInProgress = false;
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
                visible: _getProgressTaskInProgress == false,
                replacement: Center(child: CircularProgressIndicator()),
                child: ListView.separated(
                  itemBuilder:
                      (context, index) =>
                          taskCard(taskStatus: TaskStatus.Progress, taskModel:_progressTaskList[index], refreashParents: (){
                            _getAllProgressTasks();
                          },),
                  separatorBuilder: (context, index) => const SizedBox(height: 4),
                  itemCount: _progressTaskList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
