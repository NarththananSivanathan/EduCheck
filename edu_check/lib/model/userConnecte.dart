class UserConnecte {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String roleUrl;
  final String classeUrl;

  UserConnecte({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.roleUrl,
    required this.classeUrl,
  });

  factory UserConnecte.fromJson(Map<String, dynamic> json) {
    final String selfUrl = json['_links']['self']['href'];
    final int id = int.parse(selfUrl.split('/').last);

    final String roleUrl = json['_links']['role']['href'];
    final String classeUrl = json['_links']['classe']['href'];

    return UserConnecte(
      id: id,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      email: json['email'] as String,
      roleUrl: roleUrl,
      classeUrl: classeUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'roleUrl': roleUrl,
      'classeUrl': classeUrl,
    };
  }
}
