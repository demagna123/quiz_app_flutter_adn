class Score {
  final int totalScore;
  final List<ScoreByTheme> scoreByTheme;
  final List<ScoreByLevel> scoreByLevel;

  Score({
    required this.totalScore,
    required this.scoreByTheme,
    required this.scoreByLevel,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      totalScore: json['total_score'] ?? 0,
      scoreByTheme: (json['score_by_theme'] as List<dynamic>?)
          ?.map((e) => ScoreByTheme.fromJson(e))
          .toList() ?? [],
      scoreByLevel: (json['score_by_level'] as List<dynamic>?)
          ?.map((e) => ScoreByLevel.fromJson(e))
          .toList() ?? [],
    );
  }
}

class ScoreByTheme {
  final String levelTheme;
  final int totalPoints;

  ScoreByTheme({
    required this.levelTheme,
    required this.totalPoints,
  });

  factory ScoreByTheme.fromJson(Map<String, dynamic> json) {
    return ScoreByTheme(
      levelTheme: json['level_theme'] ?? '',
      totalPoints: json['total_points'] ?? 0,
    );
  }
}

class ScoreByLevel {
  final String level;
  final int totalPoints;

  ScoreByLevel({
    required this.level,
    required this.totalPoints,
  });

  factory ScoreByLevel.fromJson(Map<String, dynamic> json) {
    return ScoreByLevel(
      level: json['level'] ?? '',
      totalPoints: json['total_points'] ?? 0,
    );
  }
}
