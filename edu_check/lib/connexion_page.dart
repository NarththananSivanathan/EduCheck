import 'dart:convert';
import 'package:edu_check/model/userConnecte.dart';
import 'package:edu_check/vue/admin/accueil_admin.dart';
import 'package:edu_check/vue/etudiant/accueil_etudiant.dart';
import 'package:edu_check/vue/formateur/accueil_formateur.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class _ConnexionPageState extends State<ConnexionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connexion"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Identifiant'),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mot de Passe'),
            ),
            ElevatedButton(
                onPressed: () {
                  connexion(_emailController.text, _passwordController.text);
                },
                child: Text('Connexion')),
          ],
        ),
      ),
    );
  }

  Future<void> connexion(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        int userId = responseData['id'];
        String userRole = responseData['role']['roleName'];
        print(userId);
        print(userRole);

        final userResponse = await http.get(
          Uri.parse('http://10.0.2.2:8080/users/$userId'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (userResponse.statusCode == 200) {
          var userData = jsonDecode(userResponse.body);
          print(userData.toString() + ' les users data');

          // Créer l'objet UserConnecte à partir des données JSON
          UserConnecte user = UserConnecte.fromJson(userData);

          print(user.toString() + ' le user');
          String userName = user.nom;
          print(userName);
          print(userRole + ' role à voir et vérifier');

          // Redirection en fonction du rôle de l'utilisateur
          switch (userRole) {
            case 'ETUDIANT':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeEtudiant(user: user)),
              );
              break;
            case 'FORMATEUR':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home_formateur(user: user)),
              );
              break;
            case 'ADMINISTRATEUR':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home_admin(userName: userName)),
              );
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Rôle utilisateur non reconnu')),
              );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erreur lors de la récupération des détails de l\'utilisateur')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Nom d\'utilisateur ou mot de passe incorrect')),
        );
      }
    } catch (e) {
      print("Erreur lors de la connexion: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Une erreur s\'est produite lors de la connexion')),
      );
    }
  }
}
