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
    // Récupération initiale des users
    print(levelProvider.fetchLevels());
  }

  @override
  Widget build(BuildContext context) {
    // final levelProvider = Provider.of<LevelProvider>(context, listen: false);

    void _showCreateThemeDialog(BuildContext context) {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController _levelNameController =
          TextEditingController();
      final levelProvider = Provider.of<LevelProvider>(context, listen: false);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Créer une nouvelle phase"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _levelNameController,
              decoration: InputDecoration(
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
              child: Text("Annuler"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text("Créer"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final levelName = _levelNameController.text.trim();

                  // Créer l'objet ThemeModel

                  final newlevel = LevelModel(
                    // id: DateTime.now().millisecondsSinceEpoch,
                    name: levelName,
                    // OK ici car on a vérifié juste au-dessus
                  );

                  await levelProvider.addLevel(newlevel);

                  Navigator.of(context).pop(); // Ferme la pop-up
                }
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Expanded(
        child: Consumer<LevelProvider>(
          builder: (context, provider, child) {
            if (provider.levels.isEmpty) {
              return Center(
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: provider.levels.length,
                itemBuilder: (context, index) {
                  final level = provider.levels[index];
                  return ListTile(
                    // onLongPress: () {
                    //   _showDialog(context, user);
                    // },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThemeScreen(levelmode: level),
                        ),
                      );
                    },
                    leading: Text(
                      "Phase: ${level.id}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    title: Text(
                      level.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    // subtitle: Text(user.email),
                    // trailing: Text(user.phone_number),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateThemeDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
