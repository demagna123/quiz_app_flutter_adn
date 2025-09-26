import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/auth.dart';
import 'package:quiz_app/providers/user_answer.dart';

class StatistiqueScreen extends StatefulWidget {
  const StatistiqueScreen({super.key});

  @override
  State<StatistiqueScreen> createState() => _StatistiqueScreenState();
}

class _StatistiqueScreenState extends State<StatistiqueScreen> {
@override

void initState() {

  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final userToken = Provider.of<AuthProvider>(context, listen: false).token;
    
    if (userToken != null) {
      Provider.of<UserAnswerProvider>(context, listen: false).setToken(userToken);
      Provider.of<UserAnswerProvider>(context, listen: false).fetchScore();
    }
  });

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques')),
      body: Consumer<UserAnswerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingScore) {
            return const Center(child: CircularProgressIndicator());
          }

          final score = provider.score;

          if (score == null) {
            return const Center(child: Text('Aucun score disponible'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  'Score total : ${score.totalScore}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Scores par thème :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                ...score.scoreByTheme.map((e) => ListTile(
                      title: Text(e.levelTheme),
                      trailing: Text('${e.totalPoints} pts'),
                    )),
                const SizedBox(height: 20),
                const Text(
                  'Scores par niveau :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                ...score.scoreByLevel.map((e) => ListTile(
                      title: Text(e.level),
                      trailing: Text('${e.totalPoints} pts'),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
