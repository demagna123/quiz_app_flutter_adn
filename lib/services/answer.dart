import 'package:dio/dio.dart';
import 'package:quiz_app/models/answer.dart';

class AnswerApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Récupère toutes les réponses
  Future<List<AnswerModel>> getAnswers() async {
    try {
      final response = await _dio.get('/answers');
      final List data = response.data['answers'] ?? [];

      return data.map((json) => AnswerModel.fromJson(json)).toList();
    } catch (e) {
      print('Erreur getAnswers: $e');
      return [];
    }
  }

  /// Ajouter une réponse
  Future<void> addAnswer(AnswerModel answer) async {
    try {
      final response = await _dio.post(
        '/answers',
        data: answer.toJson(),
      );

      print("Réponse créée : ${response.data}");
    } catch (e) {
      print("Erreur création réponse : $e");
    }
  }
}
