import 'package:flutter/widgets.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/services/auth.dart';

class AuthProvider with ChangeNotifier {
  final AuthApiService _apiService = AuthApiService();

  UserModel? _user;
  String? _token;

  UserModel? get user => _user;
  String? get token => _token;

  bool get isAuthenticated => _user != null && _token != null;

  Future<UserModel?> login(UserModel user) async {
    final response = await _apiService.login(user);

    if (response != null) {
      _user = response.user;
      _token = response.token;
      notifyListeners();
      return _user;
    } else {
      return null;
    }
  }

  Future<void> addUser(UserModel user) async {
    await _apiService.addUser(user);
    notifyListeners();
  }
}
