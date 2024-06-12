import 'package:flutter/material.dart';
import 'connexion_page.dart';

void main() {
  runApp(const Principal());
}

class Principal extends StatelessWidget {
  const Principal ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduCheck',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: ConnexionPage(),
    );
  }
}



