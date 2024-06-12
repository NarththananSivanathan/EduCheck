import 'package:flutter/material.dart';
import 'package:edu_check/model/userConnecte.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilEtudiant extends StatefulWidget {
  final UserConnecte user;

  ProfilEtudiant({required this.user});

  @override
  _ProfilEtudiantState createState() => _ProfilEtudiantState();
}

class _ProfilEtudiantState extends State<ProfilEtudiant> {
  String? nomClasse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClassName();
  }

  Future<void> fetchClassName() async {
    try {
      final response = await http.get(Uri.parse(widget.user.classeUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          nomClasse =
              data['nom']; // Assurez-vous que le nom du champ est correct
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load class name');
      }
    } catch (error) {
      setState(() {
        nomClasse = 'Erreur de chargement';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Etudiant'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 75.0,
                backgroundColor: Colors.teal,
                child: Icon(
                  Icons.person,
                  size: 75.0,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              "${widget.user.nom} ${widget.user.prenom}",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: ListTile(
                leading: Icon(Icons.email, color: Colors.teal),
                title: Text(
                  "Email",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(widget.user.email),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: ListTile(
                leading: Icon(Icons.class_, color: Colors.teal),
                title: Text(
                  "Classe",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                subtitle: isLoading
                    ? CircularProgressIndicator()
                    : Text(nomClasse ?? 'Aucune classe trouvée'),
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
