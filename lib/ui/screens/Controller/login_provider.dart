import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/user_model.dart';
import '../../../data/services/api_caller.dart';
import '../../../data/utils/constant.dart';
import 'auth_controller.dart';

class LoginProvider extends ChangeNotifier{
  bool _signInInProgress = false;
  String? _errorMessage;
  bool get signInInProgress => _signInInProgress;
  String? get getErrorMessage => _errorMessage;

  Future<bool> signIn(String email , String password) async {
    bool isSucccess = false;
    _signInInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": email,
      "password":password,
    };
    ApiResponse response =
    await ApiCaller.postRequest(url: Urls.login, body: requestBody);
    debugPrint('Response: ${response.responseData}');
    debugPrint('Status: ${response.responseData['status']}');

    if (response.isSuccess == true && response.responseData['status'] == 'success') {
      UserModel userModel = UserModel.fromJson(response.responseData['data']);
      String accessToken  = response.responseData['token'];
      await AuthController.saveUserData(userModel, accessToken);

      debugPrint('User from AuthController: ${AuthController.userModel}');
      debugPrint('Token from AuthController: ${AuthController.accessToken}');
      debugPrint('Token saved: ${AuthController.accessToken}');

      isSucccess = true;
      _errorMessage = null;

    } else {

      _errorMessage = response.errorMessage ?? 'An error occurred';
      isSucccess = false;

    }
    _signInInProgress = false;
    notifyListeners();
    return isSucccess;
  }
}