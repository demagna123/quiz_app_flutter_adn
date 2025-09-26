import 'package:dio/dio.dart';
import 'package:quiz_app/models/user_anser.dart';

class UserAnswerApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<void> sendUserAnswer(UserAnswerModel userAnswer) async {
    try {
      final response = await _dio.post(
        '/answers/submitAnswer',
        data: userAnswer.toJson(),
      );
      print("Réponse envoyée : ${response.data}");
    } catch (e) {
      print("Erreur lors de l'envoi : $e");
    }
  }

  Future<Response> getUserScore() async {
    try {
      final response = await _dio.get('/user/score');
      return response;
    } catch (e) {
      print("Erreur lors de la récupération du score : $e");
      rethrow;
    }
  }
}
