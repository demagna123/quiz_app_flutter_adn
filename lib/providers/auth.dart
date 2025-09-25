import 'package:flutter/material.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/services/auth.dart';

class AuthProvider with ChangeNotifier {
  final AuthApiService _apiService = AuthApiService();

  Future<bool> login(UserModel user) async {
    bool resp = await _apiService.login(user);
    if (resp) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addUser(UserModel user) async {
    await _apiService.addUser(user);
    notifyListeners();
  }
}
