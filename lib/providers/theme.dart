import 'package:flutter/material.dart';
import 'package:quiz_app/models/theme.dart';
import 'package:quiz_app/services/theme.dart';

class ThemeProvider with ChangeNotifier {
  final ThemeApiService _apiService = ThemeApiService();

  ThemeModel? selecteTheme;
  List<ThemeModel> _themes = [];

  List<ThemeModel> get themes => _themes;

  Future<void> fetchLevels() async {
    _themes = await _apiService.getThemes();
    notifyListeners();
  }

  Future<void> addTheme(ThemeModel theme) async {
    await _apiService.addTheme(theme);
    notifyListeners();
  }
}
