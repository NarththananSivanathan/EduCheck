import 'role.dart';
import 'classe.dart';

class User {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String password;
  final Role role;
  final Classe classe;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.role,
    required this.classe,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: Role.fromJson(json['role']),
      classe: Classe.fromJson(json['classe']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'password': password,
      'role': role.toJson(),
      'classe': classe.toJson(),
    };
  }
}
