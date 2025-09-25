import 'package:flutter/material.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/pages/home/accueil.dart';
import 'package:quiz_app/pages/home/parametre.dart';
import 'package:quiz_app/pages/home/profile.dart';
import 'package:quiz_app/pages/home/quiz.dart';
import 'package:quiz_app/pages/home/startistique.dart';

class HomeScreen extends StatefulWidget {
  final UserModel? user;

  HomeScreen({required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homePages = [AccueilScreen(), QuizScreen(), StatistiqueScreen(),  ParametreScreen()];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF451E70),
        title: Text("QuizPro", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notification_add, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilScreen(user: widget.user),
                ),
              );
            },
            icon: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
      body: homePages[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Quiz'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stast'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'parametre'),
        ],
      ),
    );
  }
}
