class Role {
  final int id;
  final String roleName;

  Role({
    required this.id,
    required this.roleName,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    final String classUrl = json['_links']['self']['href'];
    final int id = int.parse(classUrl.split('/').last);
    return Role(
      id: id,
      roleName: json['roleName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'roleName': roleName,
    };
  }
}
