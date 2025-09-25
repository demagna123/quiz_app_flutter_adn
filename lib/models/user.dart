class UserModel {
  int? id;
  String email;
  String? name;

  UserModel({this.id, required this.email, this.name});

  // Convert JSON to Task Model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      name: json['name'],
      email: json['email'],
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'name': name, 'email': email};
    return data;
  }
}
