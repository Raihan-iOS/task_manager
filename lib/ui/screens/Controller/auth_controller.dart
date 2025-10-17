import 'dart:convert';

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
  static Future<bool> isUserAlreadyLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    return token != null;
  }
  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_accessTokenKey);
    await sharedPreferences.remove(_userModelKey);
    accessToken = null;
    userModel = null;
    await sharedPreferences.clear();
  }

  static Future<void> updateProfile(UserModel user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userModelKey, jsonEncode(user.toJson()));
    userModel = user;
  }


}
