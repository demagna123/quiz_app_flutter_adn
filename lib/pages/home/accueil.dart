import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/pages/home/quiz.dart';
import 'package:quiz_app/providers/auth.dart';

class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user; // ton user connecté

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Accueil"),
      //   backgroundColor: Colors.green,
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Message de bienvenue ---
              Text(
                "Bienvenue ${user?.name ?? "Invité"} ",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF451E70),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // --- Bouton pour aller au Quiz ---
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                label: const Text(
                  "Commencer le Quiz",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF451E70),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
