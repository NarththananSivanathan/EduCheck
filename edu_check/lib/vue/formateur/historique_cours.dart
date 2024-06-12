import 'dart:convert';

import 'package:edu_check/model/userConnecte.dart';
import 'package:edu_check/vue/formateur/app_bar_formateur.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CourseHistoryScreen extends StatefulWidget {
  final UserConnecte user;

  CourseHistoryScreen({required this.user});

  @override
  _CourseHistoryScreenState createState() => _CourseHistoryScreenState();
}

class _CourseHistoryScreenState extends State<CourseHistoryScreen> {
  List<dynamic> courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/cours/${widget.user.id}'));
    if (response.statusCode == 200) {
      setState(() {
        courses = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFormateur(
        title: 'Historique des cours ',
        user: widget.user,
      ),
      drawer: DrawerFormateur(
        user: widget.user,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '${widget.user.nom} ${widget.user.prenom}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Créneau',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Cours',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  final date = course['dateCours'].split('T')[0];
                  return courseItem(
                      date, course['creneau'], course['nomDucours']);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget courseItem(String date, String creneau, String course) {
    return Card(
      color: Colors.greenAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              creneau,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              course,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
