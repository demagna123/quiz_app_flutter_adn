import 'package:dio/dio.dart';
import 'package:quiz_app/models/user_anser.dart';

class UserAnswerApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<void> sendUserAnswer(UserAnswerModel userAnser) async {
    try {
      final response = await _dio.post(
        '/answers/submitAnswer',
        data: userAnser.toJson(),
      );

      print("Utilisateur créé : ${response.data}");
    } catch (e) {
      print("Erreur lors de l'envoi : $e");
    }
  }
}
