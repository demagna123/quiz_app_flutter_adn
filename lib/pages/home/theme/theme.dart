import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/level.dart';
import 'package:quiz_app/models/theme.dart';
import 'package:quiz_app/pages/home/theme/question.dart';
import 'package:quiz_app/providers/level.dart';
import 'package:quiz_app/providers/theme.dart';

class ThemeScreen extends StatefulWidget {
  final LevelModel? levelmode;
  ThemeScreen({required this.levelmode});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  void initState() {
    super.initState();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider
        .fetchLevels(); // Assure-toi que cette méthode est bien async si nécessaire
  }

  @override
  Widget build(BuildContext context) {
    void _showCreateThemeDialog(BuildContext context) {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController _themeNameController =
          TextEditingController();
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Créer un nouveau thème"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _themeNameController,
              decoration: InputDecoration(
                labelText: "Nom du thème",
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
                  final themeName = _themeNameController.text.trim();

                  // Créer l'objet ThemeModel
                  if (widget.levelmode?.id == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Impossible de créer le thème : niveau sans ID",
                        ),
                      ),
                    );
                    return;
                  }

                  final newTheme = ThemeModel(
                    // id: DateTime.now().millisecondsSinceEpoch,
                    name: themeName,
                    level_id: widget
                        .levelmode!
                        .id!, // OK ici car on a vérifié juste au-dessus
                  );

                  await themeProvider.addTheme(newTheme);

                  Navigator.of(context).pop(); // Ferme la pop-up
                }
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Consumer2<ThemeProvider, LevelProvider>(
        builder: (context, themeProvider, levelProvider, child) {
          if (themeProvider.themes.isEmpty || levelProvider.levels.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            );
          } else {
            //  Filtrer les thèmes par niveau sélectionné
            final filteredThemes = themeProvider.themes
                .where((theme) => theme.level_id == widget.levelmode?.id)
                .toList();

            return ListView.builder(
              itemCount: filteredThemes.length,
              itemBuilder: (context, index) {
                final theme = filteredThemes[index];

                // Trouver le Level correspondant si nécessaire
                final LevelModel? level = levelProvider.levels
                    .where((lvl) => lvl.id == theme.level_id)
                    .toList()
                    .cast<LevelModel?>()
                    .firstOrNull;

                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                       builder: (context) => QuestionScreen(themeId: theme.id!),

                      ),
                    );
                  },
                  leading: Text(
                    "Theme: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  title: Text(
                    theme.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  subtitle: Text(
                    "Niveau: ${level?.name ?? 'Inconnu'}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateThemeDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
