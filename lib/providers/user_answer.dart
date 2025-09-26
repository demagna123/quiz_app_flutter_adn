import 'package:flutter/material.dart';
import 'package:quiz_app/models/user_anser.dart';
import 'package:quiz_app/models/score_model.dart';
import 'package:quiz_app/services/user_answer.dart';

class UserAnswerProvider with ChangeNotifier {
  final UserAnswerApiService _apiService = UserAnswerApiService();

  Score? _score;
  bool _isLoadingScore = false;

  Score? get score => _score;
  bool get isLoadingScore => _isLoadingScore;

  // Configurer le token pour toutes les requêtes
  void setToken(String token) {
    _apiService.setToken(token);
  }

  Future<void> addUserAnswer(UserAnswerModel userAnswer) async {
    await _apiService.sendUserAnswer(userAnswer);
    notifyListeners();
  }

  Future<void> fetchScore() async {
    _isLoadingScore = true;
    notifyListeners();

    try {
      final response = await _apiService.getUserScore();
      if (response.statusCode == 200) {
        _score = Score.fromJson(response.data);
      }
    } catch (e) {
      print('Erreur fetchScore: $e');
    } finally {
      _isLoadingScore = false;
      notifyListeners();
    }
  }
}
