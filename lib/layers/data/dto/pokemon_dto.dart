import 'dart:convert';

class PokemonDto {
  final int? id;
  final String? name;
  final String? photo;
  final int? height;
  final int? weight;
  final List<String> types;

  PokemonDto({
    required this.id,
    required this.name,
    required this.photo,
    required this.height,
    required this.weight,
    required this.types,
  });

  factory PokemonDto.fromRawJson(String str) => PokemonDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PokemonDto.fromJson(Map<String, dynamic> json) => PokemonDto(
        id: json['id'],
        name: json['name'] ?? '',
        photo: json['sprites'] != null && json['sprites']['front_default'] != null ? json['sprites']['front_default'] : null,
        height: json['height'],
        weight: json['weight'],
        types: json['types'] == null
            ? []
            : List<String>.from(json['types'].map((type) => type['type'] != null && type['type']['name'] != null ? type['type']['name'] : '')),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "height": height,
        "weight": weight,
        "types": types,
      };
}
