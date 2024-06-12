import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String apiUrl = 'http://10.0.2.2:8080/users';

  Future<List<dynamic>> fetchUsers() async {
    //final apiUrl = 'http://10.0.2.2:8080/users';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> usersJson = jsonResponse['_embedded']['users'];
      print(
          'Users JSON: $usersJson'); // Ajoutez cette ligne pour voir les données reçues
      return usersJson;
    } else {
      print('Failed to load users');
      throw Exception('Failed to load users');
    }
  }

  Future<List<dynamic>> fetchEtudiants() async {
    final apiUrli = 'http://10.0.2.2:8080/users-by-role?roleName=ETUDIANT';
    final response = await http.get(Uri.parse(apiUrli));

    if (response.statusCode == 200) {
      //final Map<String, dynamic> usersJson = jsonDecode(response.body);
      final List<dynamic> usersJson = jsonDecode(response.body);
      print('Users JSON: $usersJson');
      return usersJson;
    } else {
      print('Failed to load users');
      throw Exception('Failed to load users');
    }
  }

   Future<List<dynamic>> fetchFormateurs() async {
    final apiUrli = 'http://10.0.2.2:8080/users-by-role?roleName=FORMATEUR';
    final response = await http.get(Uri.parse(apiUrli));

    if (response.statusCode == 200) {
      //final Map<String, dynamic> usersJson = jsonDecode(response.body);
      final List<dynamic> usersJson = jsonDecode(response.body);
      print('Users JSON: $usersJson');
      return usersJson;
    } else {
      print('Failed to load users');
      throw Exception('Failed to load users');
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      final apiUrli = 'http://10.0.2.2:8080/user';
      print('Sending user data: $userData');

      final response = await http.post(
        Uri.parse(apiUrli),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to create user');
      }
    } catch (error) {
      throw Exception('Failed to create user: $error');
    }
  }
}
