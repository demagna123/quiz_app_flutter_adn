import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/answer.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/pages/home/quiz.dart';
import 'package:quiz_app/providers/answer.dart';
import 'package:quiz_app/providers/auth.dart';
import 'package:quiz_app/providers/question.dart';

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
              final answers = answerProvider.getAnswersForQuestion(
                question.id!,
              );

              return Card(
                margin: EdgeInsets.all(12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Q: ${question.description}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text("${question.marke} pts"),
                      SizedBox(height: 12),

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
                      ElevatedButton.icon(
                        onPressed: () => _openAddAnswerDialog(question.id!),
                        icon: Icon(Icons.add),
                        label: Text("Ajouter une réponse"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: _submitAnswers,
            label: Text("Soumettre"),
            icon: Icon(Icons.check),
          ),
          SizedBox(height: 12),
          FloatingActionButton.extended(
            // onPressed: (){},
            onPressed: () => _openAddQuestionDialog(),
            label: Text("Ajouter Question"),
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _submitAnswers() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.id;
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Utilisateur non connecté !")));
      return;
    }

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
        'http://127.0.0.1:8000/api/answers/submitAnswers',
        data: {'answers': answers},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('Réponse serveur: ${response.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Réponses envoyées avec succès !")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuizScreen()),
      );
    } catch (e) {
      print("Erreur lors de l'envoi : $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur lors de l'envoi !")));
    }
  }

  void _openAddQuestionDialog() {
    final _descriptionController = TextEditingController();
    final _markeController = TextEditingController();
    final questionProvider = Provider.of<QuestionProvider>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ajouter une question"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description de la question",
                ),
              ),
              TextField(
                controller: _markeController,
                decoration: InputDecoration(labelText: "Nombre de points"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                final description = _descriptionController.text.trim();
                final marke = int.tryParse(_markeController.text.trim()) ?? 0;

                if (description.isEmpty || marke <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Veuillez remplir correctement tous les champs.",
                      ),
                    ),
                  );
                  return;
                }

                QuestionModel newQuestion = QuestionModel(
                  level_theme_id: widget.themeId,
                  description: description,
                  marke: marke,
                );
                // await _addQuestion(description, marke);
                await questionProvider.addQuestion(newQuestion);
                Navigator.pop(context); // fermer le modal
              },
              child: Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  void _openAddAnswerDialog(int questionId) {
    final _descriptionController = TextEditingController();
    bool _isCorrect = false;

    final answerProvider = Provider.of<AnswerProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ajouter une réponse"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Texte de la réponse"),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isCorrect,
                    onChanged: (val) {
                      _isCorrect = val ?? false;
                      (context as Element).markNeedsBuild(); // pour refresh
                    },
                  ),
                  Text("Bonne réponse ?"),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                final description = _descriptionController.text.trim();

                if (description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Veuillez entrer une réponse.")),
                  );
                  return;
                }

                AnswerModel newAnswer = AnswerModel(
                  question_id: questionId,
                  description: description,
                  is_correct: _isCorrect,
                );

                await answerProvider.addAnswer(newAnswer);
                Navigator.pop(context); // fermer la modal
              },
              child: Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }
}
