import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pokedex_app/layers/data/dto/pokemon_dto.dart';

abstract class PokemonRemoteDataSource {
  /// Returns the list of pokemons from the api
  Future<Either<Exception, List<PokemonDto>>> getPokemons();
  /// Return the detail of a pokemon by id
  Future<Either<Exception, PokemonDto>> getPokemon(int id);
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  @override
  Future<Either<Exception, List<PokemonDto>>> getPokemons() async {
    try {
      Response response;
      response = await Dio().get('https://pokeapi.co/api/v2/pokemon?limit=151');

      List<PokemonDto> listOfPokemons = [];
      try {
        response.data['results'].forEach((pokemon) {
          listOfPokemons.add(PokemonDto.fromJson(pokemon));
        });
        log('successfully loaded -> [${listOfPokemons.length}]');
        return right(listOfPokemons);
      } on Error catch (e) {
        log('incorrect $e');
        return left(Exception());
      }
    }
    // Para cualquier excepcion de Dio
    on DioException catch (_) {
      return left(Exception());
    }
    // Para cualquier otra excepcion
    on Error catch (_) {
      return left(Exception());
    }
  }

  @override
  Future<Either<Exception, PokemonDto>> getPokemon(int id) async {
    try {
      Response response;
      response = await Dio().get('https://pokeapi.co/api/v2/pokemon/$id');

      PokemonDto? pokemon;
      try {
        pokemon = PokemonDto.fromJson(response.data);
      } on Error catch (_) {
        return left(Exception());
      }
      return right(pokemon);
    }
    // Para cualquier excepcion de Dio
    on DioException catch (_) {
      return left(Exception());
    }
    // Para cualquier otra excepcion
    on Error catch (_) {
      return left(Exception());
    }
  }
}
