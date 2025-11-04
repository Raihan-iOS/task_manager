import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/services/api_caller.dart';
import '../../../data/utils/constant.dart';

class NewTaskAddProvider extends ChangeNotifier{
  bool _addTaskInProgress = false;
  String? _errorMessage;
  bool get addTaskInProgress => _addTaskInProgress;
  String? get getErrorMessage => _errorMessage;

  Future<bool> addNewTaskApi(String title , String description) async {
    bool isSucccess = false;
    _addTaskInProgress = true;
    notifyListeners();
    Map<String,dynamic> requestBody = {
      "title":title,
      "description": description,
      "status":"New"
    };
    ApiResponse apiResponse = await ApiCaller.postRequest(url: Urls.createTask,body:requestBody);

    if (apiResponse.isSuccess == true) {

      isSucccess = true;
      _errorMessage = null;

    } else {

      _errorMessage = apiResponse.errorMessage ?? 'An error occurred';
      isSucccess = false;

    }
    _addTaskInProgress = false;
    notifyListeners();
    return isSucccess;
  }
}