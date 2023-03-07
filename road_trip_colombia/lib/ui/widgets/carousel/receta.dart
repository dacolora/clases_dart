class Receta {
  final int id;
  final String name;
  final String image;
  final String description;

  const Receta({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory Receta.fromJson(Map<String, dynamic> json) => Receta(
        id: json['id'],
        name: json['name'],
        image: json['img'],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': name,
        'image': image,
        'description': description,
      };
  Receta copy() => Receta(
        id: id,
        name: name,
        image: image,
        description: description,
      );
}
