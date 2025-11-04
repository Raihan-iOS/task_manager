// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/ui/screens/home/new_task_screen.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

import '../../../data/services/api_caller.dart';
import '../../../data/utils/constant.dart';
import '../../widgets/SnackBarMessage.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {

  bool _getCancelledTaskInProgress = false;
  List<TaskModel> _cancelledTaskList = [];

  initState() {
    super.initState();
    _getAllCancelledTasks();
  }
  //! Get cancelled  task Data

  Future<void> _getAllCancelledTasks() async {
    _getCancelledTaskInProgress = true;
    setState(() {});

    ApiResponse apiResponse = await ApiCaller.getRequest(url: Urls.cancelledTasks);

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
      _cancelledTaskList = list;
      _getCancelledTaskInProgress = false;
      setState(() {});
    } else {
      ShowSnackBarMessage(context, apiResponse.errorMessage!);
      _getCancelledTaskInProgress = false;
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
                visible: _getCancelledTaskInProgress == false,
                replacement: Center(child: CircularProgressIndicator()),
                child: ListView.separated(
                  itemBuilder:
                      (context, index) =>
                          taskCard(taskStatus: TaskStatus.Canceled, taskModel:_cancelledTaskList[index], refreashParents: (){
                            _getAllCancelledTasks();
                          },),
                  separatorBuilder: (context, index) => const SizedBox(height: 4),
                  itemCount: _cancelledTaskList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
