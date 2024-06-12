import 'package:edu_check/model/classe.dart';
import 'package:edu_check/model/role.dart';
import 'package:edu_check/services/classes_services.dart';
import 'package:edu_check/services/role_services.dart';
import 'package:edu_check/services/user_service.dart';
import 'package:edu_check/vue/admin/app_bar_admin.dart';
import 'package:flutter/material.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  String? _selectedRoleId;
  String? _selectedClasseId;
  late bool _classeRequired = true; // Initialisé à true par défaut

  List<Role> _roles = [];
  List<Classe> _classes = [];

  @override
  void initState() {
    super.initState();
    _fetchRolesAndClasses();
  }

  Future<void> _fetchRolesAndClasses() async {
    try {
      final roles = await RoleService().fetchRoles();
      final classes = await ClasseService().fetchClasses();
      setState(() {
        _roles = roles;
        _classes = classes;
      });
    } catch (error) {
      print('Error fetching roles and classes: $error');
    }
  }

  Future<void> _validateAndCreateUser() async {
    if (_formKey.currentState!.validate()) {
      final userData = {
        'nom': _nomController.text,
        'prenom': _prenomController.text,
        'email': _emailController.text,
        'password': _motDePasseController.text,
        'role': {'id': _selectedRoleId},
        //'classe': {'id': _selectedClasseId},
        if (_classeRequired) 'classe': {'id': _selectedClasseId}, // Ajout conditionnel de la classe
      };

      try {
        await UserService().createUser(userData);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Détails de l\'utilisateur créé'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Email: ${_emailController.text}'),
                  Text('Mot de passe: ${_motDePasseController.text}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Retourne à la page précédente
                  },
                  child: Text('Fermer'),
                ),
              ],
            );
          },
        );
      } catch (error) {
        print('Error creating user: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur lors de la création de l\'utilisateur')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAdmin(title: 'Créer un utilisateur'),
      drawer: DrawerAdmin(Name: 'Administration'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le prénom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le email';
                  }
                  // Ajoutez ici une validation d'email si nécessaire
                  return null;
                },
              ),
              TextFormField(
                controller: _motDePasseController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le mot de passe';
                  }
                  // Ajoutez ici une validation du mot de passe si nécessaire
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedRoleId,
                onChanged: (String? value) {
                  setState(() {
                    _selectedRoleId = value;
                    _classeRequired = value == 'ETUDIANT';
                  });
                },
                items: _roles.map<DropdownMenuItem<String>>((Role role) {
                  return DropdownMenuItem<String>(
                    value: role.id.toString(),
                    child: Text(role.roleName),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Role'),
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un rôle';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedClasseId,
                onChanged: (String? value) {
                  setState(() {
                    _selectedClasseId = value!;
                  });
                },
                items: _classes.map<DropdownMenuItem<String>>((Classe classe) {
                  return DropdownMenuItem<String>(
                    value: classe.id.toString(),
                    child: Text(classe.nom),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Classe'),
                validator: (value) {
                  if (_classeRequired && (value == null || value.isEmpty)) {
                    return 'Veuillez sélectionner une classe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _validateAndCreateUser,
                child: Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
