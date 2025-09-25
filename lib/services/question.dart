import 'package:dio/dio.dart';
import 'package:quiz_app/models/question.dart';

class QuestionApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<QuestionModel>> getQuestions() async {
    try {
      final response = await _dio.get('/questions');
      final List levels = response.data['questions'];
      
      return levels.map((level) => QuestionModel.fromJson(level)).toList();
      
    } catch (e) {
      print('Erreur getLevels: $e');
      return [];
    }
  }

  Future<void> addQuestion(QuestionModel question) async {
    try {
      final response = await _dio.post('/questions', data: question.toJson());

      print("Utilisateur créé : ${response.data}");
    } catch (e) {
      print("Erreur lors de l'envoi : $e");
    }
  }
  // Future<List<AnswerModel>> getAnswers() async {
  //   try {
  //     final response = await _dio.get('/answers');
  //     final List levels = response.data['answers'];
      
  //     return levels.map((level) => AnswerModel.fromJson(level)).toList();
      
  //   } catch (e) {
  //     print('Erreur getLevels: $e');
  //     return [];
  //   }
  // }
}


