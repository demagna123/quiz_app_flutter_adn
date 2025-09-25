class ThemeModel {
  int? id;
  String name;
 final int level_id;
  String? description;

  ThemeModel({
    this.id,
    required this.name,
    required this.level_id,
    this.description,
  });

  // Convert JSON to Task Model
  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      name: json['name'],
      level_id: json['level_id'],
      description: json['description'],
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'level_id': level_id,
      'description': description,
    };
    return data;
  }
}
