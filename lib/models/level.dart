class LevelModel {
  int? id;
  String name;

  LevelModel({this.id, required this.name});

  // Convert JSON to Task Model
  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      name: json['name'],
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'name': name};
    return data;
  }
}
