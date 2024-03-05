import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:pokedex_app/layers/data/dto/pokemon/pokemon_dto.dart';
import 'package:pokedex_app/layers/data/source/local/pokemon_local_data_source.dart';
import 'package:pokedex_app/layers/data/source/network/pokemon_remote_data_source.dart';
import 'package:pokedex_app/layers/domain/repository/pokemon/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonLocalDataSource pokemonLocalDataSource;
  final PokemonRemoteDataSource pokemonRemoteDataSource;

  PokemonRepositoryImpl({required this.pokemonLocalDataSource, required this.pokemonRemoteDataSource});

  @override
  Future<Either<Exception, List<PokemonDto>>> getPokemons() async {
    log('PokemonRepositoryImpl -> getPokemons()');
    // if(contectado){
    return await pokemonRemoteDataSource.getPokemons().then((remoteResult) {
      return remoteResult.fold(
        (exception) async {
          return await pokemonLocalDataSource.getPokemonsList().then((localResult) {
            return localResult.fold(
              (exception) => Future.value(left(Exception())),
              (pokemons) => Future.value(right(pokemons)),
            );
          });
        },
        (pokemons) async {
          await pokemonLocalDataSource.savePokemonsList(pokemonsList: pokemons);
          return Future.value(right(pokemons));
        },
      );
    });
    // } else{
    //   return pokemonLocalDataSource.getPokemonsList();
    // }
  }

  @override
  Future<Either<Exception, List<PokemonDto>>> getCapturedPokemons() {
    log('PokemonRepositoryImpl -> getCapturedPokemons()');
    return pokemonLocalDataSource.getCapturedPokemonsList();
  }

  @override
  Future<Either<Exception, PokemonDto>> getPokemon(int id) async {
    log('PokemonRepositoryImpl -> getPokemon()');
    bool isCaptured = false;
    // if(contectado){
    return await pokemonRemoteDataSource.getPokemon(id).then((remoteResult) {
      return remoteResult.fold(
        (exception) async {
          return await pokemonLocalDataSource.getPokemon(id: id).then((localResult) {
            return localResult.fold(
              (exception) => Future.value(left(Exception())),
              (pokemon) async {
                await pokemonLocalDataSource.isCaptured(pokemon: pokemon).then((isCapturedResult) {
                  isCapturedResult.fold(
                    (exception) => isCaptured = false,
                    (pokemon) => isCaptured = pokemon != null,
                  );
                });
                PokemonDto newPokemon = pokemon.copyWith(isCaptured: isCaptured);
                return Future.value(right(newPokemon));
              },
            );
          });
        },
        (pokemon) async {
          await pokemonLocalDataSource.savePokemon(pokemon: pokemon);
          await pokemonLocalDataSource.isCaptured(pokemon: pokemon).then((isCapturedResult) {
            isCapturedResult.fold(
              (exception) => isCaptured = false,
              (pokemon) => isCaptured = pokemon != null,
            );
          });
          return Future.value(right(pokemon.copyWith(isCaptured: isCaptured)));
        },
      );
    });
    // } else{
    //   return pokemonLocalDataSource.getPokemon(id: id);
    // }
  }

  @override
  Future<Either<Exception, PokemonDto?>> captureOrReleasePokemon(PokemonDto pokemon) async {
    log('PokemonRepositoryImpl -> captureOrReleasePokemon()');
    return await pokemonLocalDataSource.captureOrReleasePokemon(pokemon: pokemon);
  }
}
