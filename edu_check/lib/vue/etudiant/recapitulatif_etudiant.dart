import 'dart:convert';
import 'package:edu_check/model/userConnecte.dart';
import 'package:edu_check/vue/etudiant/justifier_absence.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app_bar_etudiant.dart';

class RecapPage extends StatelessWidget {
  final UserConnecte user;

  RecapPage({required this.user});

  Future<List<dynamic>> fetchData() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/cours/etudiant/${user.id}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarEtudiant(
        title: 'Voir récapitulatif',
        user: user,
      ),
      drawer: DrawerEtudiant(user: user),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<dynamic> apiData = snapshot.data!;
            return RecapDataList(apiData: apiData, user: user);
          }
        },
      ),
    );
  }
}

class RecapDataList extends StatelessWidget {
  final List<dynamic> apiData;
  final UserConnecte user;

  RecapDataList({required this.apiData, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Nom de l\'utilisateur',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: apiData.length,
              itemBuilder: (context, index) {
                final item = apiData[index];
                return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JustifierAbsencePage(
                                user: user, apiData: item)),
                      );
                    },
                    child: DataRowWidget(
                      date: item[2].split(
                          'T')[0], // Formatage pour obtenir uniquement la date
                      creneau: item[3],
                      cours: item[4],
                      presence: item[5] ? '✅' : '❌',
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DataRowWidget extends StatelessWidget {
  final String date;
  final String creneau;
  final String cours;
  final String presence;

  DataRowWidget({
    required this.date,
    required this.creneau,
    required this.cours,
    required this.presence,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Text(date, textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 1,
              child: Text(creneau, textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 1,
              child: Text(cours, textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 1,
              child: Text(presence, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
