class QuestionModel {
  int? id;
  int level_theme_id;
  String description;
  int marke;

  QuestionModel({
    this.id,
    required this.level_theme_id,
    required this.description,
    required this.marke,
  });

  // Convert JSON to Task Model
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      level_theme_id: json['level_theme_id'],
      description: json['description'],
      marke: json['marke'],
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'level_theme_id': level_theme_id,
      'description': description,
      'marke': marke,
    };
    return data;
  }
}
