import 'package:edu_check/vue/admin/app_bar_admin.dart';
import 'package:edu_check/vue/admin/liste_classe.dart';
import 'package:edu_check/vue/admin/liste_etudiant.dart';
import 'package:edu_check/vue/admin/liste_formateur.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home_admin extends StatefulWidget {
  final String userName;

  const Home_admin({super.key, required this.userName});

  @override
  _Home_adminState createState() => _Home_adminState();
}

class _Home_adminState extends State<Home_admin> {
  String studentsCount = '0';
  String classesCount = '0';
  String formateursCount = '0';

  @override
  void initState() {
    super.initState();
    fetchCounts();
  }

  Future<void> fetchCounts() async {
    try {
      final studentsResponse = await http
          .get(Uri.parse('http://10.0.2.2:8080/count/students'));
      final classesResponse =
          await http.get(Uri.parse('http://10.0.2.2:8080/count/classes'));
      final formateursResponse = await http
          .get(Uri.parse('http://10.0.2.2:8080/count/formateurs'));

      if (studentsResponse.statusCode == 200) {
        setState(() {
          studentsCount = jsonDecode(studentsResponse.body).toString();
        });
      }
      if (classesResponse.statusCode == 200) {
        setState(() {
          classesCount = jsonDecode(classesResponse.body).toString();
        });
      }
      if (formateursResponse.statusCode == 200) {
        setState(() {
          formateursCount = jsonDecode(formateursResponse.body).toString();
        });
      }
    } catch (error) {
      print('Error fetching counts: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAdmin(title: 'Accueil'),
      drawer: DrawerAdmin(Name: widget.userName),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Administration',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleWidget(
                  title: 'Étudiants',
                  value: studentsCount, // Nombre total d'étudiants
                ),
                CircleWidget(
                  title: 'Classes',
                  value: classesCount, // Nombre total de classes
                ),
                CircleWidget(
                  title: 'Formateurs',
                  value: formateursCount, // Nombre total de formateurs
                ),
              ],
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListeClassesPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.lightGreen), // Couleur de fond vert clair
              ),
              child: Text('Classes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListeEtudiantsPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.lightGreen), // Couleur de fond vert clair
              ),
              child: Text('Étudiants'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListeFormateursPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.lightGreen), // Couleur de fond vert clair
              ),
              child: Text('Formateurs'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CircleWidget extends StatelessWidget {
  final String title;
  final String value;

  CircleWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.lightGreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
