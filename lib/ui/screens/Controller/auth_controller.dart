import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/models/user_model.dart';

class AuthController{
  static String _accessTokenKey = 'token';
  static String _userModelKey = 'user';

  static String? accessToken;
  static UserModel? userModel;

  static Future<void> saveUserData(UserModel user,String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    await sharedPreferences.setString(_userModelKey, jsonEncode(user.toJson()));
    accessToken = token;
    userModel = user;
  }

  static Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString(_accessTokenKey) ;
    if (token != null) {
      accessToken = token;
     String? userData = sharedPreferences.getString(_userModelKey);
     userModel = UserModel.fromJson(jsonDecode(userData!));
    }


  }

}
