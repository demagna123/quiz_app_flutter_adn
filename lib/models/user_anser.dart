class UserAnswerModel {
  final int userId;
  final int questionId;
  final int selectedAnswerId;

  UserAnswerModel({
    required this.userId,
    required this.questionId,
    required this.selectedAnswerId,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "question_id": questionId,
      "answer_id": selectedAnswerId,
    };
  }
}
