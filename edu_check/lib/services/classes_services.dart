import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/classe.dart';


class ClasseService {
  static const String apiUrl = 'http://10.0.2.2:8080/classes';

  Future<List<Classe>> fetchClasses() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('_embedded') && jsonResponse['_embedded'].containsKey('classes')) {
        final List<dynamic> classesJson = jsonResponse['_embedded']['classes'];
        print('Classes JSON: $classesJson');
        return classesJson.map((json) {
          print('Class JSON: $json');
          return Classe.fromJson(json);
        }).toList();
      } else {
        throw Exception('Structure JSON inattendue');
      }
    } else {
      throw Exception('Failed to load classes');
    }
  }

  Future<void> createClasse(String nom) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nom': nom,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create classe');
    }
  }

  Future<void> deleteClasse(int id) async {
    print('ID de la classe à supprimer : $id');
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    print('Code de statut de la réponse : ${response.statusCode}');

    if (response.statusCode != 204) {
      throw Exception('Failed to delete classe');
    }
  }
}

