import 'package:dartz/dartz.dart';
import 'package:pokedex_app/layers/data/dto/pokemon_dto.dart';

abstract class PokemonRepository {
  /// Pokemons list that come from the api
  Future<Either<Exception, List<PokemonDto>>> getPokemons();
  Future<Either<Exception, PokemonDto>> getPokemon(int id);
  /// Captured pokemons list
  Future<Either<Exception, List<PokemonDto>>> getCapturedPokemons();
}
