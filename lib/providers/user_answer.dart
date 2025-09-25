import 'package:flutter/material.dart';
import 'package:quiz_app/models/user_anser.dart';
import 'package:quiz_app/services/user_answer.dart';

class UserAnswerProvider with ChangeNotifier{
final UserAnswerApiService _apiService = UserAnswerApiService();

  // List<UserAnswerModel> _themes = [];

  // List<ThemeModel> get themes => _themes;

  // Future<void> fetchLevels() async {
  //   _themes = await _apiService.getThemes();
  //   notifyListeners();
  // }

  Future<void> addUserAnser(UserAnswerModel userAnswer) async {
    await _apiService.sendUserAnswer(userAnswer);
    notifyListeners();
  }
}