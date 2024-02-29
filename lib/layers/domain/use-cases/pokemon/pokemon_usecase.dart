import 'package:dartz/dartz.dart';
import 'package:pokedex_app/layers/data/dto/pokemon_dto.dart';
import 'package:pokedex_app/layers/domain/repository/pokemon/pokemon_repository.dart';

class PokemonUseCase{
  final PokemonRepository pokemonRepository;

  PokemonUseCase({required this.pokemonRepository});

  Future<Either<Exception, List<PokemonDto>>> getPokemons() {
    return pokemonRepository.getPokemons();
  }

  Future<Either<Exception, List<PokemonDto>>> getCapturedPokemons() {
    return pokemonRepository.getCapturedPokemons();
  }

  Future<Either<Exception, PokemonDto>> getPokemon(int id) {
    return pokemonRepository.getPokemon(id);
  }
}