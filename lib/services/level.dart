import 'package:dio/dio.dart';
import 'package:quiz_app/models/level.dart';

class LevelApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<LevelModel>> getLevels() async {
    try {
      final response = await _dio.get('/levels');
      final List levels = response.data['levels'];
      return levels.map((level) => LevelModel.fromJson(level)).toList();
    } catch (e) {
      print('Erreur getLevels: $e');
      return [];
    }
  }

  Future<void> addLevel(LevelModel level) async {
    try {
      final response = await _dio.post('/levels', data: level.toJson());

      print("Utilisateur créé : ${response.data}");
    } catch (e) {
      print("Erreur lors de l'envoi : $e");
    }
  }
}
