import 'package:dio/dio.dart';
import 'package:quiz_app/models/user.dart';

class AuthApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<bool> login(UserModel user) async {
  try {
    final response = await _dio.post('/login', data: user.toJson());

    if (response.statusCode == 200) {
      final data = response.data; // ✅ Pas besoin de jsonDecode

      bool exists = data['exists'] == true;

      if (exists) {
        print("Connexion réussie : ${data['message']}");
        // Tu peux aussi sauvegarder un token ici si présent dans `data`
        return true;
      } else {
        print("Utilisateur non inscrit : ${data['message']}");
        return false;
      }
    } else {
      print("Erreur HTTP : ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Erreur de connexion : $e");
    return false;
  }
}


  // Add a new Task
  Future<void> addUser(UserModel user) async {
    try {
      final response = await _dio.post('/register', data: user.toJson());

      print("Utilisateur créé : ${response.data}");
    } catch (e) {
      print("Erreur lors de l'envoi : $e");
    }
  }
}
