import 'package:dartz/dartz.dart';
import 'package:pokedex_app/layers/data/dto/pokemon_dto.dart';
import 'package:pokedex_app/layers/data/source/local/pokemon_local_data_source.dart';
import 'package:pokedex_app/layers/data/source/network/pokemon_remote_data_source.dart';
import 'package:pokedex_app/layers/domain/repository/pokemon/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonLocalDataSource pokemonLocalDataSource;
  final PokemonRemoteDataSource pokemonRemoteDataSource;

  PokemonRepositoryImpl({required this.pokemonLocalDataSource, required this.pokemonRemoteDataSource});

  @override
  Future<Either<Exception, List<PokemonDto>>> getPokemons() {
    // if(contectado){
    return pokemonRemoteDataSource.getPokemons();
    // }
  }

  @override
  Future<Either<Exception, List<PokemonDto>>> getCapturedPokemons() {
    // if(contectado){
    return Future.value(Left(Exception()));
    // }
  }

  @override
  Future<Either<Exception, PokemonDto>> getPokemon(int id) {
    // if(contectado){
    return Future.value(Left(Exception()));
    // }
  }
}
