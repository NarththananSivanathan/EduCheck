import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/role.dart';

class RoleService {
  static const String apiUrl = 'http://10.0.2.2:8080/roles';

  Future<List<Role>> fetchRoles() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('_embedded') &&
          jsonResponse['_embedded'].containsKey('roles')) {
        final List<dynamic> rolesJson = jsonResponse['_embedded']['roles'];
        print('Roles JSON: $rolesJson');
        return rolesJson.map((json) {
          print('Role JSON: $json');
          return Role.fromJson(json);
        }).toList();
      } else {
        throw Exception('Structure JSON inattendue');
      }
    } else {
      throw Exception('Failed to load roles');
    }
  }
}
