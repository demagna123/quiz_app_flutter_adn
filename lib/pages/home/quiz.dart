import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/level.dart';
import 'package:quiz_app/pages/home/theme/theme.dart';
import 'package:quiz_app/providers/level.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    final levelProvider = Provider.of<LevelProvider>(context, listen: false);
    levelProvider.fetchLevels();
  }

  void _showCreateLevelDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _levelNameController = TextEditingController();
    final levelProvider = Provider.of<LevelProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Créer une nouvelle phase"),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _levelNameController,
            decoration: const InputDecoration(
              labelText: "Nom de la phase",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Veuillez entrer un nom";
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Annuler"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text("Créer"),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final levelName = _levelNameController.text.trim();
                final newlevel = LevelModel(name: levelName);

                await levelProvider.addLevel(newlevel);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Les differentes phases"),
        // backgroundColor: Colors.green,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.account_circle),
        //     onPressed: () {
        //       // futur accès au profil
        //     },
        //   ),
        // ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Bienvenue / intro
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Bonjour \nPrêt à tester tes connaissances ? ",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          // --- Liste des phases
          Expanded(
            child: Consumer<LevelProvider>(
              builder: (context, provider, child) {
                if (provider.levels.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: provider.levels.length,
                    itemBuilder: (context, index) {
                      final level = provider.levels[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ThemeScreen(levelmode: level),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            child: Text(
                              "${level.id}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            level.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateLevelDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
