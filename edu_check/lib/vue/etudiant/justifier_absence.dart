import 'dart:convert';
import 'package:edu_check/model/userConnecte.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app_bar_etudiant.dart';

class JustifierAbsencePage extends StatefulWidget {
  final UserConnecte user;
  final dynamic apiData;

  JustifierAbsencePage({required this.user, required this.apiData});

  @override
  _JustifierAbsencePageState createState() => _JustifierAbsencePageState();
}

class _JustifierAbsencePageState extends State<JustifierAbsencePage> {
  String? selectedReason;
  TextEditingController justificationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarEtudiant(title: 'Justifier une absence' , user: widget.user,),
      drawer: DrawerEtudiant(user: widget.user),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.user.nom,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date de l\'absence:'),
                Text(
                  widget.apiData[2].split(
                      'T')[0], // Affichez la date extraite de l'élément 2
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Motif de l\'absence:'),
                DropdownButton<String>(
                  value: selectedReason,
                  onChanged: (String? value) {
                    setState(() {
                      selectedReason = value;
                    });
                  },
                  items: <String>[
                    'Maladie',
                    'Rendez-vous médical',
                    'Urgence familiale',
                    'Autre',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: justificationController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Justification',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Vérifier si une raison a été sélectionnée
                if (selectedReason == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Veuillez sélectionner un motif d\'absence.'),
                    ),
                  );
                  return; // Arrêter l'exécution si aucune raison n'est sélectionnée
                }

                // Vérifier si une justification a été saisie
                if (justificationController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Veuillez entrer une justification.'),
                    ),
                  );
                  return; // Arrêter l'exécution si aucune justification n'a été saisie
                }

                // Construire le corps de la requête
                final Map<String, String> requestBody = {
                  "justificatif": justificationController.text,
                  "motif": selectedReason!,
                };

                // Faire la requête PATCH vers l'API
                // Remarque : vous devez remplacer 'userid' et 'coursid' par les valeurs appropriées
                http.patch(
                  Uri.parse(
                      'http://10.0.2.2:8080/emargements/${widget.user.id}/${widget.apiData[1]}'),
                  body: jsonEncode(requestBody),
                  headers: {'Content-Type': 'application/json'},
                ).then((response) {
                  if (response.statusCode == 200) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Absence justifiée avec succès.'),
                      ),
                    );
                    // Vous pouvez également naviguer vers une autre page après la validation réussie
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Erreur lors de la justification de l\'absence.'),
                      ),
                    );
                  }
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Erreur lors de la justification de l\'absence : $error'),
                    ),
                  );
                });
              },
              child: Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }
}
