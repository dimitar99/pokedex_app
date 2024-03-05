import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pokedex_app/core/services/dio-interceptor/dio_interceptor.dart';
import 'package:pokedex_app/layers/data/dto/pokemon/pokemon_dto.dart';
import 'package:pokedex_app/layers/presentation/shared/constants/constants.dart';

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
      response = await DioInterceptor().request().get('${Constants.baseUrl}/pokemon?limit=151');

      List<PokemonDto> listOfPokemons = [];
      try {
        response.data['results'].forEach((pokemon) {
          listOfPokemons.add(PokemonDto.fromJson(pokemon));
        });
        log('successfully loaded -> [${listOfPokemons.length}] pokemons');
        return right(listOfPokemons);
      } on Error catch (_) {
        return left(Exception());
      }
    }
    // For any Dio exception
    on DioException catch (_) {
      return left(Exception());
    }
    // For any other exception
    on Error catch (_) {
      return left(Exception());
    }
  }

  @override
  Future<Either<Exception, PokemonDto>> getPokemon(int id) async {
    try {
      Response response;
      response = await DioInterceptor().request().get('${Constants.baseUrl}/pokemon/$id');

      PokemonDto? pokemon;
      try {
        pokemon = PokemonDto.fromJson(response.data);
      } on Error catch (_) {
        return left(Exception());
      }
      return right(pokemon.copyWith(url: '${Constants.baseUrl}/pokemon/$id'));
    }
    // For any Dio exception
    on DioException catch (_) {
      return left(Exception());
    }
    // For any other exception
    on Error catch (_) {
      return left(Exception());
    }
  }
}
