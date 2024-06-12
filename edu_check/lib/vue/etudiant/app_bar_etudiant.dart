import 'package:edu_check/model/userConnecte.dart';
import 'package:edu_check/vue/etudiant/profil_etudiant.dart';
import 'package:edu_check/vue/etudiant/recapitulatif_etudiant.dart';
import 'package:flutter/material.dart';

import '../../connexion_page.dart';

class AppBarEtudiant extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final UserConnecte user;

  AppBarEtudiant({required this.title, required this.user});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.blue,
      actions: [
        IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilEtudiant(user: user)),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class DrawerEtudiant extends StatelessWidget {
  final UserConnecte user;

  DrawerEtudiant({required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Profil'),
            leading: Icon(Icons.account_circle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilEtudiant(user: user)),
              );
            },
          ),
          ListTile(
            title: Text('Voir Récapitulatif'),
            leading: Icon(Icons.list),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecapPage(user: user)),
              );
            },
          ),
          /*ListTile(
            title: Text('Justifier une absence'),
            leading: Icon(Icons.message),
            onTap: () {
              /*Navigator.push(
                  context,
                MaterialPageRoute(
                    builder: (context) => JustifierAbsencePage(user: user)),
                  );*/
            },
          ),*/
          ListTile(
            title: Text('Se déconnecter'),
            leading: Icon(Icons.logout),
            onTap: () {
              seDeconnecter(context);
            },
          ),
        ],
      ),
    );
  }

  void seDeconnecter(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ConnexionPage(),
      ),
      (Route<dynamic> route) =>
          false, // Cette fonction retourne false pour supprimer toutes les routes de la pile
    );
  }
}
