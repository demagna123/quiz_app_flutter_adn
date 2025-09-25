import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/pages/auth/login.dart';
import 'package:quiz_app/providers/answer.dart';
import 'package:quiz_app/providers/auth.dart';
import 'package:quiz_app/providers/level.dart';
import 'package:quiz_app/providers/question.dart';
import 'package:quiz_app/providers/theme.dart';
import 'package:quiz_app/providers/user_answer.dart';

void main() {
  runApp(MultiProvider(
    providers:
     [
      ChangeNotifierProvider(
      create: (_) => AuthProvider()
      ),
      ChangeNotifierProvider(
      create: (_) => LevelProvider()
      ),
      ChangeNotifierProvider(
      create: (_) => ThemeProvider()
      ),
      ChangeNotifierProvider(
      create: (_) => QuestionProvider()
      ),

      ChangeNotifierProvider(
      create: (_) => AnswerProvider()
      ),
      
      ChangeNotifierProvider(
      create: (_) => UserAnswerProvider()
      ),
      
      ],
      child: const MyApp(),
    ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
