import 'dart:convert';

import 'package:http/http.dart' as http;

class CoursService {
  Future<List<Map<String, dynamic>>> getAllCours() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.10:8000/api/cours'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la récupération des cours');
      }
      return json.decode(response.body);
      //return response.body;
      //return json.decode(response.body);
    } catch (e) {
      print(e.toString());
      throw Exception('Erreur lors de la récupération des cours');
    }
    //return json.decode(response.body);
    //return response.body;
    //return json.decode(response.body);
  }

  /* Future<void> creerCours(Map<String, dynamic> coursData) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/courses'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(coursData),
      );

      print(response.body);

      if (response.statusCode != 201) {
        throw Exception('Erreur lors de la création du cours');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Erreur lors de la création du cours');
    }
  } */

  Future<int> creerCours(Map<String, dynamic> coursData) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/courses'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(coursData),
      );

      //print('Response status: ${response.statusCode}');

      if (response.statusCode == 201) {
        final location = response.headers['location'];
        //print('Location header: $location');

        final coursId = int.tryParse(location?.split('/').last ?? '');
        //print('Extracted course ID: $coursId');

        if (coursId != null && coursId != 0) {
          //print('Course ID extracted successfully: $coursId');
          return coursId;
        } else {
          //print('Failed to extract valid course ID from location header');
          throw Exception(
              'Failed to extract valid course ID from location header');
        }
      } else {
       // print('Failed to create course: ${response.statusCode}');
        throw Exception('Failed to create course: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error creating course: $e');
      throw Exception('Error creating course: $e');
    }
  }
}
