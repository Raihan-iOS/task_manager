import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/models/task_status_count_model.dart';
import '../../../data/services/api_caller.dart';
import '../../../data/utils/constant.dart';

class TaskCountProvider extends ChangeNotifier{
  bool _taskCountInProgress = false;
  String? _errorMessage;
  bool get taskCountInProgress => _taskCountInProgress;
  String? get getErrorMessage => _errorMessage;
  List<TaskStatusCountModel> _taskStatusCountList = [];
  List<TaskStatusCountModel> get taskStatusCountList => _taskStatusCountList;


  Future<bool> getTaskCount() async {
    bool isSucccess = false;
    _taskCountInProgress = true;
    notifyListeners();


    ApiResponse response =
    await ApiCaller.getRequest(url: Urls.allTaskStatusCount);

    if (response.isSuccess == true ) {
      List<TaskStatusCountModel> taskStatusList = [];
      for(Map<String,dynamic> taskStatus in response.responseData['data']){
        taskStatusList.add(TaskStatusCountModel.fromJson(taskStatus));
      }
      _taskStatusCountList = taskStatusList;

      isSucccess = true;
      _errorMessage = null;

    } else {

      _errorMessage = response.errorMessage ?? 'An error occurred';
      isSucccess = false;

    }
    _taskCountInProgress = false;
    notifyListeners();
    return isSucccess;
  }
}