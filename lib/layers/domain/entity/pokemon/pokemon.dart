class Pokemon {
  int? id;
  String? name;
  String? photo;
  int? height;
  int? weight;
  List<String> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.photo,
    required this.height,
    required this.weight,
    required this.types,
  });
}
