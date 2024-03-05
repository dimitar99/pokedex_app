import 'package:pokedex_app/layers/domain/entity/sprites/sprites.dart';

class SpritesDto extends Sprites {
  SpritesDto({required super.frontDefault});

  factory SpritesDto.fromJson(Map<String, dynamic> json) => SpritesDto(frontDefault: json["front_default"]);

  Map<String, dynamic> toJson() => {"front_default": frontDefault};

  static final empty = Sprites(frontDefault: '');
}
