import 'package:dio/dio.dart';
import 'package:quiz_app/models/user.dart';

class AuthApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<AuthResponse?> login(UserModel user) async {
    try {
      final response = await _dio.post('/login', data: user.toJson());

      if (response.statusCode == 200) {
        final data = response.data;

        bool exists = data['exists'] == true;

        if (exists) {
          print("Connexion réussie : ${data['message']}");

          final userJson = data['user']; // l'utilisateur depuis l'API
          final token = data['token'];   // le token depuis l'API

          return AuthResponse(
            user: UserModel.fromJson(userJson),
            token: token,
          );
        } else {
          print("Utilisateur non inscrit : ${data['message']}");
          return null;
        }
      } else {
        print("Erreur HTTP : ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Erreur de connexion : $e");
      return null;
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      final response = await _dio.post('/register', data: user.toJson());
      print("Utilisateur créé : ${response.data}");
    } catch (e) {
      print("Erreur lors de l'envoi : $e");
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      final response = await _dio.put('/update/id', data: user.toJson());
      print("Utilisateur créé : ${response.data}");
    } catch (e) {
      print("Erreur lors de l'envoi : $e");
    }
  }
}
