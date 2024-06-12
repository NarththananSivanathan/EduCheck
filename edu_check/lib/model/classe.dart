
class Classe {
  final int id;
  final String nom;

  Classe({
    required this.id,
    required this.nom,
  });

  factory Classe.fromJson(Map<String, dynamic> json) {
    final String classUrl = json['_links']['self']['href'];
    final int id = int.parse(classUrl.split('/').last);
    return Classe(
      id: id,
      nom: json['nom'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
    };
  }
}
