import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/services/question.dart';

class QuestionProvider with ChangeNotifier {
  final QuestionApiService _apiService = QuestionApiService();

  QuestionModel? selecteQuestion;



  List<QuestionModel> _questions = [];

  List<QuestionModel> get questions => _questions;

  Future<void> fetchQuestions() async {
    _questions = await _apiService.getQuestions();
    notifyListeners();
  }

  Future<void> addQuestion(QuestionModel question) async {
    await _apiService.addQuestion(question);
    notifyListeners();
  }
}
