import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/models/task_model.dart';
import '../../../data/services/api_caller.dart';
import '../../../data/utils/constant.dart';

class NewTaskListProvider extends ChangeNotifier{
  bool _newTaskListInProgress = false;
  String? _errorMessage;
  bool get newTaskListInProgress => _newTaskListInProgress;
  String? get getErrorMessage => _errorMessage;

  List<TaskModel> _newTaskList = [];
  List<TaskModel> get newTaskList => _newTaskList;

  Future<bool> newTaskListFetch() async {
    bool isSucccess = false;
    _newTaskListInProgress = true;
    notifyListeners();

    ApiResponse response =
    await ApiCaller.getRequest(url: Urls.newTasks);
    debugPrint('Response: ${response.responseData}');

    if (response.isSuccess == true) {
      isSucccess = true;
      _errorMessage = null;
      List<TaskModel> list = [];

      var data = response.responseData['data'];
      if (data is List) {
        for (var task in data) {
          if (task is Map<String, dynamic>) {
            list.add(TaskModel.fromJson(task));
          }
        }
      }
      _newTaskList = list;
      _newTaskListInProgress = false;

    } else {
      _newTaskListInProgress = false;
      _errorMessage = response.errorMessage ?? 'An error occurred';
      isSucccess = false;

    }
    _newTaskListInProgress = false;
    notifyListeners();
    return isSucccess;
  }
}