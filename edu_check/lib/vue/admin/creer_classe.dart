import 'package:edu_check/services/classes_services.dart';
import 'package:edu_check/vue/admin/app_bar_admin.dart';
import 'package:flutter/material.dart';

class CreerClassePage extends StatefulWidget {
  @override
  _CreerClassePageState createState() => _CreerClassePageState();
}

class _CreerClassePageState extends State<CreerClassePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomClasse = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ClasseService().createClasse(_nomClasse.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Classe créée avec succès')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création de la classe')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAdmin(title: 'Créer une classe'),
      drawer: DrawerAdmin(Name: 'Administration'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nomClasse,
                decoration: InputDecoration(
                  labelText: 'Nom de la classe',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de la classe';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Valider'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
