import 'package:edu_check/model/classe.dart';
import 'package:edu_check/services/classes_services.dart';
import 'package:edu_check/vue/admin/app_bar_admin.dart';
import 'package:edu_check/vue/admin/creer_classe.dart';
import 'package:flutter/material.dart';

class ListeClassesPage extends StatefulWidget {
  @override
  _ListeClassesPageState createState() => _ListeClassesPageState();
}

class _ListeClassesPageState extends State<ListeClassesPage> {
  late Future<List<Classe>> futureClasses;

  @override
  void initState() {
    super.initState();
    futureClasses = ClasseService().fetchClasses();
  }

void _deleteClasse(int id) async {
  try {
    await ClasseService().deleteClasse(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Classe supprimée avec succès')),
    );
    
    // Attendre la suppression de la classe avant de mettre à jour futureClasses
    final updatedClasses = await ClasseService().fetchClasses();
    setState(() {
      futureClasses = Future.value(updatedClasses);
    });
  } catch (e) {
    print('Erreur lors de la suppression de la classe: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la suppression de la classe')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAdmin(title: 'Liste des classes'),
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
                    MaterialPageRoute(builder: (context) => CreerClassePage()),
                  ).then((_) {
                    setState(() {
                      futureClasses = ClasseService().fetchClasses();
                    });
                  });
                },
                child: Text('Créer une classe'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightGreen),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Classe>>(
              future: futureClasses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Erreur de chargement des classes'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucune classe trouvée'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Classe classe = snapshot.data![index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(classe.nom),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirmation'),
                                      content: Text(
                                          'Voulez-vous vraiment supprimer cette classe ?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Annuler'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _deleteClasse(classe.id);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Confirmer'),
                                        ),
                                      ],
                                    );
                                  },
                                );
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
