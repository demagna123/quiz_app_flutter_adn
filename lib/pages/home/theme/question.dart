import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/user_anser.dart';
import 'package:quiz_app/providers/answer.dart';
import 'package:quiz_app/providers/question.dart';
import 'package:quiz_app/providers/user_answer.dart';

class QuestionScreen extends StatefulWidget {
  final int themeId;

  const QuestionScreen({required this.themeId, super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  // Map pour stocker les réponses choisies par question ID
  Map<int, int?> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    final questionProvider = Provider.of<QuestionProvider>(
      context,
      listen: false,
    );
    final answerProvider = Provider.of<AnswerProvider>(context, listen: false);

    questionProvider.fetchQuestions();
    answerProvider.fetchAnswers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Questions du thème ${widget.themeId}")),
      body: Consumer2<QuestionProvider, AnswerProvider>(
        builder: (context, questionProvider, answerProvider, child) {
          final questions = questionProvider.questions
              .where((q) => q.level_theme_id == widget.themeId)
              .toList();

          if (questions.isEmpty) {
            return Center(child: Text("Aucune question pour ce thème."));
          }

          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              final answers =
                  answerProvider.getAnswersForQuestion(question.id!);

              return Card(
                margin: EdgeInsets.all(12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🟢 Question
                      Text(
                        "Q: ${question.description}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text("${question.marke} pts"),
                      SizedBox(height: 12),

                      // 🟡 Réponses avec sélection
                      if (answers.isEmpty)
                        Text("Aucune réponse enregistrée.")
                      else
                        Column(
                          children: answers.map((answer) {
                            return RadioListTile<int>(
                              title: Text(answer.description),
                              value: answer.id!,
                              groupValue: selectedAnswers[question.id],
                              onChanged: (val) {
                                setState(() {
                                  selectedAnswers[question.id!] = val;
                                });
                              },
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitAnswers,
        label: Text("Soumettre"),
        icon: Icon(Icons.check),
      ),
    );
  }

  void _submitAnswers() async {
  final userId = 1;

  List<Map<String, dynamic>> answers = [];

  selectedAnswers.forEach((questionId, selectedAnswerId) {
    if (selectedAnswerId != null) {
      answers.add({
        'user_id': userId,
        'question_id': questionId,
        'answer_id': selectedAnswerId,
      });
    }
  });

  try {
    final dio = Dio();
    final response = await dio.post(
      'http://127.0.0.1:8000/api/answers/submitAnswers', // route à créer
      data: {'answers': answers},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    print('Réponse serveur: ${response.data}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Réponses envoyées avec succès !")),
    );
  } catch (e) {
    print("Erreur lors de l'envoi : $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur lors de l'envoi !")),
    );
  }
}

}
