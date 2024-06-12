import 'package:edu_check/services/user_service.dart';
import 'package:edu_check/vue/admin/app_bar_admin.dart';
import 'package:edu_check/vue/admin/creer_etudiant.dart';
import 'package:flutter/material.dart';

class ListeFormateursPage extends StatefulWidget {
  @override
  _ListeFormateursPageState createState() => _ListeFormateursPageState();
}

class _ListeFormateursPageState extends State<ListeFormateursPage> {
  late Future<List<dynamic>> futureEtudiants;

  @override
  void initState() {
    super.initState();
    futureEtudiants = UserService().fetchFormateurs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAdmin(title: 'Liste des formateurs'),
      drawer: DrawerAdmin(Name: 'Administration'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateUserPage()),
                  );
                },
                child: Text('Créer un utilisateur'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightGreen),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: futureEtudiants,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Center(
                      child: Text('Erreur de chargement des utilisateurs'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun utilisateur trouvé'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final utilisateur = snapshot.data![index];
                      final classe = utilisateur['classe'];
                      final nomClasse = classe != null ? classe['nom'] : 'N/A';
                      return Column(
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${utilisateur['nom']} ${utilisateur['prenom']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ), // Ajoute un espace entre les deux colonnes
                                Expanded(
                                  flex: 3,
                                  child: Text(nomClasse),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Ajoutez ici la logique de suppression de l'utilisateur
                              },
                            ),
                          ),
                          Divider(color: Colors.black),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
