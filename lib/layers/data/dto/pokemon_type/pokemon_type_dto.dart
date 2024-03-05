import 'dart:convert';

import 'package:pokedex_app/layers/domain/entity/pokemon_type/pokemon_type.dart';

class PokemonTypeDto extends PokemonType {
  PokemonTypeDto({
    super.slot,
    super.type,
  });

  factory PokemonTypeDto.pokemonTypeFromJson(String str) => PokemonTypeDto.fromJson(json.decode(str));

  String pokemonTypeToJson() => json.encode(toJson());

  factory PokemonTypeDto.fromJson(Map<String, dynamic> json) => PokemonTypeDto(
        slot: json["slot"],
        type: json['type'] == null ? null : TypeDto.fromJson(json["type"]),
      );

  Map<String, dynamic> toJson() => {
        "slot": slot,
        "type": type == null ? null : (type as TypeDto).toJson(),
      };
}

class TypeDto extends Type {
  TypeDto({
    super.name,
    super.url,
  });

  factory TypeDto.fromJson(Map<String, dynamic> json) => TypeDto(
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}
