import 'package:flutter/material.dart';
import 'package:quiz_app/models/answer.dart';
import 'package:quiz_app/services/answer.dart';

class AnswerProvider with ChangeNotifier {
  final AnswerApiService _apiService = AnswerApiService();

  List<AnswerModel> _answers = [];

  List<AnswerModel> get answers => _answers;

  Future<void> fetchAnswers() async {
    _answers = await _apiService.getAnswers();
    notifyListeners();
  }

  List<AnswerModel> getAnswersForQuestion(int questionId) {
    return _answers.where((a) => a.question_id == questionId).toList();
  }

  Future<void> addAnswer(AnswerModel answer) async {
    await _apiService.addAnswer(answer);
    await fetchAnswers(); // Refresh after creation
  }
}
