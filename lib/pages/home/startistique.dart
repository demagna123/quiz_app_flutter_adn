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
        Provider.of<UserAnswerProvider>(
          context,
          listen: false,
        ).setToken(userToken);
        Provider.of<UserAnswerProvider>(context, listen: false).fetchScore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserAnswerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingScore) {
            return const Center(child: CircularProgressIndicator());
          }

          final score = provider.score;

          if (score == null) {
            return const Center(child: Text('Aucun score disponible'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Statistiques",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Score total (grand card)
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // color: Colors.blueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        'Score Total : ${score.totalScore} pts',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Scores par thème
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Scores par Thème",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: score.scoreByTheme.map((e) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.deepPurpleAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              e.levelTheme,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${e.totalPoints} pts",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 30),

                // Scores par niveau
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    " Scores par Niveau",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: score.scoreByLevel.map((e) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          // gradient: const LinearGradient(
                          //   colors: [Colors.teal, Colors.cyan],
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          // ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              e.level,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${e.totalPoints} pts",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
