import 'package:flutter/material.dart';
import 'package:quiz_app/models/level.dart';
import 'package:quiz_app/services/level.dart';

class LevelProvider with ChangeNotifier {
  final LevelApiService _apiService = LevelApiService();

  LevelModel? selectedLevel;
  List<LevelModel> _levels = [];

  List<LevelModel> get levels => _levels;

  Future<void> fetchLevels() async {
    _levels = await _apiService.getLevels();
    notifyListeners();
  }

  Future<void> addLevel(LevelModel level) async {
    await _apiService.addLevel(level);
    notifyListeners();
  }
}
