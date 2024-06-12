import 'package:edu_check/model/userConnecte.dart';
import 'package:edu_check/vue/formateur/app_bar_formateur.dart';
import 'package:edu_check/connexion_page.dart';
import 'package:edu_check/vue/formateur/declencher_appel.dart';
import 'package:edu_check/vue/formateur/historique_cours.dart';
import 'package:flutter/material.dart';

class Home_formateur extends StatelessWidget {
  final UserConnecte user;

  const Home_formateur({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFormateur(
        title: 'Accueil',
        user: user,
      ),
      drawer: DrawerFormateur(
        user: user,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          // Centrer verticalement et horizontalement
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centrer les enfants verticalement
            crossAxisAlignment: CrossAxisAlignment
                .center, // Centrer les enfants horizontalement
            children: <Widget>[
              Text(
                'Formateur: ${user.nom} - ${user.prenom}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseHistoryScreen(user: user),
                    ),
                  );
                },
                child: Text('Historique'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  minimumSize: Size(200, 50), // Largeur et hauteur des boutons
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreationCoursForm(user: user),
                    ),
                  );
                },
                child: Text('Déclencher Appel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  minimumSize: Size(200, 50), // Largeur et hauteur des boutons
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void seDeconnecter(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ConnexionPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
