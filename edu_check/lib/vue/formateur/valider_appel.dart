import 'dart:convert';

import 'package:edu_check/vue/formateur/accueil_formateur.dart';
import 'package:edu_check/vue/formateur/app_bar_formateur.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:edu_check/model/userConnecte.dart';

class EtudiantsListPage extends StatefulWidget {
  final UserConnecte user;
  final String? classeId;
  final int? coursId;

  EtudiantsListPage({required this.user, this.classeId, this.coursId});

  @override
  _EtudiantsListPageState createState() => _EtudiantsListPageState();
}

class _EtudiantsListPageState extends State<EtudiantsListPage> {
  late List<UserConnecte> _apprenants;
  late bool _isLoading = true;
  late Map<String, bool> _checkedApprenants = {};

  @override
  void initState() {
    super.initState();
    _fetchApprenants();
  }

  Future<void> _fetchApprenants() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/classes/${widget.classeId}/apprenants'));
    //print('Réponse HTTP : ${response.statusCode}');
    //print('Contenu de la réponse : ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> apprenantsData = data['_embedded']['users'];
      setState(() {
        _apprenants =
            apprenantsData.map((e) => UserConnecte.fromJson(e)).toList();
        _isLoading = false; // Mettre à jour l'état de chargement
        // Initialiser toutes les cases à cocher à true par défaut
        _apprenants.forEach((apprenant) {
          _checkedApprenants[apprenant.id.toString()] = true;
        });
      });
      //print('Apprenants récupérés : $_apprenants');
    } else {
      throw Exception('Failed to load apprenants non recupéré');
    }
  }

  Future<void> _validerAppel() async {
    // Afficher une boîte de dialogue pour confirmer la validation de l'appel
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Valider l'appel"),
          content: Text("Voulez-vous vraiment valider l'appel ?"),
          actions: <Widget>[
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirmer"),
              onPressed: () async {
                try {
                  // Parcourir la liste des étudiants
                  for (final apprenant in _apprenants) {
                    // Créer une instance d'Emargement
                    final emargementData = {
                      "user": "users/${apprenant.id}",
                      "cours": "courses/${widget.coursId}",
                      "present":
                          _checkedApprenants[apprenant.id.toString()] ?? false
                              ? 1
                              : 0
                    };

                    final response = await http.post(
                      Uri.parse('http://10.0.2.2:8080/emargements'),
                      headers: {
                        'Content-Type': 'application/json; charset=UTF-8'
                      },
                      body: jsonEncode(emargementData),
                    );

                    print(
                        'Emargement envoyé pour ${apprenant.nom} ${apprenant.prenom}: ${response.statusCode}');
                  }
                  // Afficher un message de succès ou effectuer une autre action

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Home_formateur(user: widget.user)),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Vous avez bien validé l\'appel.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  print('Erreur lors de la validation de l\'appel : $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFormateur(
        title: 'Faire et Valider Appel',
        user: widget.user,
      ),
      drawer: DrawerFormateur(
        user: widget.user,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            ) // Afficher un indicateur de chargement si les données sont en cours de récupération
          : _apprenants.isEmpty
              ? Center(
                  child: Text("Aucun étudiant trouvé"),
                ) // Afficher un message si la liste est vide
              : ListView.builder(
                  itemCount: _apprenants.length,
                  itemBuilder: (context, index) {
                    final apprenant = _apprenants[index];
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: Text('${apprenant.nom} ${apprenant.prenom}'),
                          value: _checkedApprenants[apprenant.id.toString()] ??
                              false,
                          onChanged: (bool? value) {
                            setState(() {
                              _checkedApprenants[apprenant.id.toString()] =
                                  value ?? false;
                              print(
                                  'Apprenant ${apprenant.id} checked: ${value ?? false}');
                              print('Checked apprenants: $_checkedApprenants');

                              // Vérifier si la valeur est bien true ou false
                              assert(_checkedApprenants[apprenant.id.toString()]
                                  is bool);
                            });
                          },
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1.0,
                        ),
                      ],
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _validerAppel,
        label: Text("Valider l'appel"),
        icon: Icon(Icons.check),
        backgroundColor: Colors.lightGreen,
      ),
    );
  }
}
