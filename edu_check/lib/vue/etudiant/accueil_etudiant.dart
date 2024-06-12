import 'package:edu_check/model/userConnecte.dart';
import 'package:edu_check/vue/etudiant/app_bar_etudiant.dart';
import 'package:edu_check/vue/etudiant/recapitulatif_etudiant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeEtudiant extends StatefulWidget {
  final UserConnecte user;

  const HomeEtudiant({super.key, required this.user});

  @override
  _HomeEtudiantState createState() => _HomeEtudiantState();
}

class _HomeEtudiantState extends State<HomeEtudiant> {
  double presencePercentage = 100.0;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchPresencePercentage();
  }

  Future<void> fetchPresencePercentage() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/presence/etudiant/${widget.user.id}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Data from API: $data'); // Log for debugging
        setState(() {
          presencePercentage = data;
          isLoading = false;
          hasError = false;
        });
      } else {
        print('Failed to load presence percentage: ${response.statusCode}');
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (error) {
      print('Error: $error'); // Log for debugging
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarEtudiant(title: 'Accueil' , user: widget.user,),
      drawer: DrawerEtudiant(user: widget.user),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              'Bonjour ${widget.user.nom} ${widget.user.prenom}',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 70),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.lightGreen,
                  width: 20,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : hasError
                        ? Text(
                            'Erreur de chargement',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            '${presencePercentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                                fontSize: 50,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
              ),
            ),
            SizedBox(height: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecapPage(user: widget.user)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      elevation: 5,
                      minimumSize: Size(300, 50)),
                  child: Text(
                    'Voir récapitulatif',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                SizedBox(height: 33),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
