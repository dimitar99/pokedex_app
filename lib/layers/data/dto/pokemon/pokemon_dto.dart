import 'dart:convert';
import 'package:pokedex_app/layers/data/dto/pokemon_type/pokemon_type_dto.dart';
import 'package:pokedex_app/layers/data/dto/sprites/sprites_dto.dart';
import 'package:pokedex_app/layers/domain/entity/pokemon/pokemon.dart';
import 'package:pokedex_app/layers/domain/entity/pokemon_type/pokemon_type.dart';
import 'package:pokedex_app/layers/domain/entity/sprites/sprites.dart';

class PokemonDto extends Pokemon {
  PokemonDto({
    required super.id,
    required super.name,
    required super.sprites,
    required super.height,
    required super.weight,
    required super.types,
    required super.url,
    super.isCaptured,
  });

  factory PokemonDto.fromRawJson(String str) => PokemonDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PokemonDto.fromJson(Map<String, dynamic> json) => PokemonDto(
        id: json['id'],
        name: json['name'] ?? 'Without name',
        sprites: json['sprites'] == null ? null : SpritesDto.fromJson(json['sprites']),
        height: json['height'] ?? 0,
        weight: json['weight'] ?? 0,
        types: json['types'] == null ? [] : List<PokemonTypeDto>.from(json['types'].map((type) => PokemonTypeDto.fromJson(type))),
        url: json['url'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sprites": sprites,
        "height": height,
        "weight": weight,
        "types": types,
        "url": url,
      };

  PokemonDto copyWith({
    int? id,
    String? name,
    Sprites? sprites,
    int? height,
    int? weight,
    List<PokemonType>? types,
    String? url,
    bool? isCaptured,
  }) =>
      PokemonDto(
        id: id ?? this.id,
        name: name ?? this.name,
        sprites: sprites ?? this.sprites,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        types: types ?? this.types,
        url: url ?? this.url,
        isCaptured: isCaptured ?? this.isCaptured,
      );

  static final empty = PokemonDto(id: 0, name: '', sprites: SpritesDto.empty, height: 0, weight: 0, types: [], url: "");
}
