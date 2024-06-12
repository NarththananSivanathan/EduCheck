import 'package:edu_check/model/classe.dart';
import 'package:edu_check/model/cours.dart';
import 'package:edu_check/services/classes_services.dart';
import 'package:edu_check/services/cours_services.dart';
import 'package:edu_check/model/userConnecte.dart';
import 'package:edu_check/vue/formateur/app_bar_formateur.dart';
import 'package:edu_check/vue/formateur/valider_appel.dart';
import 'package:flutter/material.dart';

class CreationCoursForm extends StatefulWidget {
  final UserConnecte user;

  CreationCoursForm({required this.user});

  @override
  _CreationCoursFormState createState() => _CreationCoursFormState();
}

class _CreationCoursFormState extends State<CreationCoursForm> {
  late DateTime _selectedDate;
  String? _selectedCreneau;
  String? _selectedClasseId;
  String _nomDuCours = '';
  List<Classe> _classes = [];

  final TextEditingController _nomCoursController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchClasses();
  }

  @override
  void dispose() {
    _nomCoursController.dispose();
    super.dispose();
  }

  Future<void> _fetchClasses() async {
    try {
      final classes = await ClasseService().fetchClasses();
      setState(() {
        _classes = classes;
      });
    } catch (error) {
      print('Error fetching roles and classes: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFormateur(
        title: 'Déclencher un Appel',
        user: widget.user,
      ),
      drawer: DrawerFormateur(
        user: widget.user,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Date du cours'),
            subtitle: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
            onTap: () => _selectDate(context),
          ),
          TextFormField(
            controller: _nomCoursController,
            // Champ pour le nom du cours
            decoration: InputDecoration(labelText: 'Nom du cours'),
            onChanged: (value) {
              setState(() {
                _nomDuCours = value;
              });
            },
          ),
          DropdownButtonFormField<String>(
            value: _selectedCreneau,
            hint: Text('Sélectionnez le créneau'),
            items: ['Matin', 'Après-midi'].map((creneau) {
              return DropdownMenuItem<String>(
                value: creneau,
                child: Text(creneau),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCreneau = value;
              });
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
              if (value == null || value.isEmpty) {
                return 'Veuillez sélectionner une classe';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Annuler'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final cours = Cours(
                    id: 0,
                    nomDucours: _nomDuCours,
                    dateCours: _selectedDate,
                    creneau: _selectedCreneau,
                    classe: '/classes/$_selectedClasseId',
                    createur: '/users/${widget.user.id}',
                  );
                  _submitCours(cours);
                },
                child: Text('Valider'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitCours(Cours cours) async {
    try {
      // Récupérer l'ID du cours après la création du cours
      int idCours = await CoursService().creerCours(cours.toJson());
      //print('ID du cours créé: $idCours');

      if (/*idCours != null &&*/ idCours != 0) {
        // Naviguer vers la page suivante pour afficher les étudiants de la classe choisie
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EtudiantsListPage(
              user: widget.user,
              classeId: _selectedClasseId,
              coursId: idCours,
            ),
          ),
        );

        // Réinitialiser le formulaire après la navigation réussie
        _resetForm();
      } else {
        // Afficher un Snackbar si l'ID du cours n'est pas valide
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : ID de cours invalide.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Afficher un Snackbar d'erreur en cas d'échec
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la création du cours : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetForm() {
    _nomCoursController.clear();
    _selectedCreneau = null;
    _selectedClasseId = null;
    _selectedDate = DateTime.now();
    setState(() {});
  }
}
