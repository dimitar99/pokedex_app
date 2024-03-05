import 'package:dartz/dartz.dart';
import 'package:pokedex_app/layers/data/dto/pokemon/pokemon_dto.dart';

abstract class PokemonRepository {
  /// Pokemons that come from the api
  Future<Either<Exception, List<PokemonDto>>> getPokemons();
  Future<Either<Exception, PokemonDto>> getPokemon(int id);
  
  /// Captured pokemons that are stored in local
  Future<Either<Exception, List<PokemonDto>>> getCapturedPokemons();
  Future<Either<Exception, PokemonDto?>> captureOrReleasePokemon(PokemonDto pokemon);
}
