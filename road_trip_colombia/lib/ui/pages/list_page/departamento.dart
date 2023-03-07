class Departamento {
  final int id;
  final String name;
  final String capital;
  final String image;
  final String description;

  const Departamento({
    required this.id,
    required this.name,
    required this.capital,
    required this.image,
    required this.description,
  });

  factory Departamento.fromJson(Map<String, dynamic> json) => Departamento(
        id: json['id'],
        name: json['name'],
        capital: json['capital'],
        image: json['img'],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': name,
        'image': image,
        'capital': capital,
        'description': description,
      };
  Departamento copy() => Departamento(
        id: id,
        name: name,
        image: image,
        capital: capital,
        description: description,
      );
}
