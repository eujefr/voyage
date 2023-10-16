import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/User.dart';

class LocalStorage {

  static Future<SharedPreferences> getInstance() async {

     return await SharedPreferences.getInstance();
  }

  static Future<String?> getToken() async {

    SharedPreferences? shared = await getInstance();

    String? token = shared.getString("token");

    return token;
  }

  static setToken(String token) async {

    await getInstance().then((value)
    => value.setString("token", token));
  }

  static Future<User> getUser() async {

    SharedPreferences? shared = await getInstance();

    String? asd = shared.getString("User");

    return User.fromJson(jsonDecode(asd!));
  }

}