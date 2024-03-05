import 'package:pokedex_app/layers/domain/entity/pokemon_type/pokemon_type.dart';
import 'package:pokedex_app/layers/domain/entity/sprites/sprites.dart';

class Pokemon {
  int? id;
  String name;
  Sprites? sprites;
  int? height;
  int? weight;
  List<PokemonType> types;
  String url;
  bool isCaptured;

  Pokemon({
    required this.id,
    required this.name,
    required this.sprites,
    required this.height,
    required this.weight,
    required this.types,
    required this.url,
    this.isCaptured = false,
  });
}
