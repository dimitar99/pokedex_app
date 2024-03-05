import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:pokedex_app/layers/data/dto/pokemon/pokemon_dto.dart';
import 'package:pokedex_app/layers/domain/repository/pokemon/pokemon_repository.dart';

class PokemonUseCase{
  final PokemonRepository pokemonRepository;

  PokemonUseCase({required this.pokemonRepository});

  Future<Either<Exception, List<PokemonDto>>> callPokemons() {
    log('PokemonUseCase -> callPokemons()');
    return pokemonRepository.getPokemons();
  }

  Future<Either<Exception, List<PokemonDto>>> callCapturedPokemons() {
    log('PokemonUseCase -> callCapturedPokemons()');
    return pokemonRepository.getCapturedPokemons();
  }

  Future<Either<Exception, PokemonDto>> callPokemon(int id) {
    log('PokemonUseCase -> callPokemon()');
    return pokemonRepository.getPokemon(id);
  }

  Future<Either<Exception, PokemonDto?>> callCaptureOrReleasePokemon(PokemonDto pokemon) {
    log('PokemonUseCase -> callCaptureOrReleasePokemon()');
    return pokemonRepository.captureOrReleasePokemon(pokemon);
  }
}