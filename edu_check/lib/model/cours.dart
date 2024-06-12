
class Cours {
  final int id;
  final String nomDucours;
  final DateTime dateCours;
  final String? creneau;
  //final Classe classe;
  final String classe;
  //final UserConnecte createur;
  final String createur;

  Cours({
    required this.id,
    required this.nomDucours,
    required this.dateCours,
    this.creneau,
    required this.classe,
    required this.createur,
  });

  factory Cours.fromJson(Map<String, dynamic> json) {
    return Cours(
        id: json['id'],
        nomDucours: json['nomDucours'],
        dateCours: DateTime.parse(json['dateCours']),
        creneau: json['creneau'],
        //classe: Classe.fromJson(json['_links']['classe']),
        classe: json['classe'],
        //createur: UserConnecte.fromJson(json['_links']['createur']),
        createur: json['createur']);
  }

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'nomDucours': nomDucours,
      'dateCours': dateCours.toIso8601String(),
      'creneau': creneau,
      //'classe': classe.toJson(),
      'classe': classe,
      //'createur': createur.toJson(),
      'createur': createur,
    };
  }
}
