import 'package:dio/dio.dart';
import 'package:quiz_app/models/theme.dart';

class ThemeApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<ThemeModel>> getThemes() async {
    try {
      final response = await _dio.get('/themes');
      final List themes = response.data['themes'];
      print(themes);
      return themes.map((theme) => ThemeModel.fromJson(theme)).toList();
    } catch (e) {
      print('Erreur getLevels: $e');
      return [];
    }
  }


  Future<void> addTheme(ThemeModel theme) async {
    try {
      final response = await _dio.post('/themes', data: theme.toJson());

      print("Utilisateur créé : ${response.data}");
    } catch (e) {
      print("Erreur lors de l'envoi : $e");
    }
  }
}
