import 'package:flutter/material.dart';
import '../../connexion_page.dart';

class AppBarAdmin extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  AppBarAdmin({required this.title});

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
            // Action à exécuter lors de l'appui sur le bouton de profil
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class DrawerAdmin extends StatelessWidget {
  final String Name;

  DrawerAdmin({required this.Name});

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
            title: Text('Formateurs'),
            leading: Icon(Icons.account_circle),
            onTap: () {
              // Naviguer vers la page de profil
            },
          ),
          ListTile(
            title: Text('Classes'),
            leading: Icon(Icons.list),
            onTap: () {
              
            },
          ),
          ListTile(
            title: Text('Etudiants'),
            leading: Icon(Icons.message),
            onTap: () {
             
            },
          ),
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
          (Route<dynamic> route) => false, // Cette fonction retourne false pour supprimer toutes les routes de la pile
    );
  }

}