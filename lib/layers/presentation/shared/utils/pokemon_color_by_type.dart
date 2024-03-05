import 'package:flutter/material.dart';
import 'package:pokedex_app/layers/presentation/shared/theme/styles.dart';

Color getPokemonColorByType(String type) {
  switch (type) {
    case 'normal':
      return normalType;
    case 'fighting':
      return fightingType;
    case 'poison':
      return poisonType;
    case 'ground':
      return groundType;
    case 'rock':
      return rockType;
    case 'bug':
      return bugType;
    case 'ghost':
      return ghostType;
    case 'steel':
      return steelType;
    case 'fire':
      return fireType;
    case 'water':
      return waterType;
    case 'grass':
      return grassType;
    case 'electric':
      return electricType;
    case 'psychic':
      return psychicType;
    case 'ice':
      return iceType;
    case 'dragon':
      return dragonType;
    case 'dark':
      return shadowType;
    case 'fairy':
      return fairyType;
    case 'shadow':
      return shadowType;
    default:
      return red;
  }
}
