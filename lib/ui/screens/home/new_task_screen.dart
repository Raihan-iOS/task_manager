import 'package:flutter/material.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/constant.dart';
import 'package:task_manager/ui/screens/home/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/SnackBarMessage.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/task_card.dart';
import 'package:task_manager/ui/widgets/task_count_by_status_card.dart';

import '../../../data/models/task_status_count_model.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});
  static const String routeName = '/new-tasks';

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  initState() {
    super.initState();
    _getAllTaskStatusCount();
  }
  bool _getNewTaskInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];

  Future<void> _getAllTaskStatusCount() async {
_getNewTaskInProgress = true;
setState(() {});
ApiResponse apiResponse = await ApiCaller.getRequest(url: Urls.allTaskStatusCount);
if (apiResponse.isSuccess == true) {
  List<TaskStatusCountModel> taskStatusList = [];
  for(Map<String,dynamic> taskStatus in apiResponse.responseData['data']){
    taskStatusList.add(TaskStatusCountModel.fromJson(taskStatus));
  }
  _taskStatusCountList = taskStatusList;
  _getNewTaskInProgress = false;
  setState(() {});
}else{
  ShowSnackBarMessage(context, apiResponse.errorMessage!);
  _getNewTaskInProgress = false;
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
            SizedBox(
              height: 90,
              child: Visibility(
                visible: _getNewTaskInProgress == false,
                replacement: CircularProgressIndicator(),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder:
                      (context, index) =>
                          TaskCountByStatus(title: _taskStatusCountList[index].status, count:  _taskStatusCountList[index].count),
                  separatorBuilder: (context, index) => const SizedBox(width: 4),
                  itemCount: _taskStatusCountList.length,
                ),
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
    Navigator.pushNamed(context, AddNewTaskScreen.routeName);
  }
}

enum TaskStatus { New, Progress, Canceled, Completed }
