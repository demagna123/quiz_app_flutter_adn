import 'package:flutter/material.dart';

class ParametreScreen extends StatefulWidget {
  const ParametreScreen({super.key});

  @override
  State<ParametreScreen> createState() => _ParametreScreenState();
}

class _ParametreScreenState extends State<ParametreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [Text("parametre")]));
  }
}
