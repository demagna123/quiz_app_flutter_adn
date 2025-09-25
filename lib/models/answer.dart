class AnswerModel {
  final int? id;
  final int question_id;
  final String description;
  final bool is_correct;

  AnswerModel({
    this.id,
    required this.question_id,
    required this.description,
    required this.is_correct,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'],
      question_id: json['question_id'],
      description: json['description'],
      is_correct: json['is_correct'] == 1 || json['is_correct'] == true,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': question_id,
      'description': description,
      'is_correct': is_correct,
    };
  }
}
