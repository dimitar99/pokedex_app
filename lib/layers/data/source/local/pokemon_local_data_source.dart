import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:pokedex_app/layers/data/dto/pokemon/pokemon_dto.dart';
import 'package:pokedex_app/layers/presentation/shared/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PokemonLocalDataSource {
  /// Pokemons List that comes from api
  Future<bool> savePokemonsList({required List<PokemonDto> pokemonsList});
  Future<Either<Exception, List<PokemonDto>>> getPokemonsList();

  /// Pokemon used for pokemon detail page
  Future<bool> savePokemon({required PokemonDto pokemon});
  Future<Either<Exception, PokemonDto>> getPokemon({required int id});

  /// Captured pokemons
  Future<Either<Exception, List<PokemonDto>>> getCapturedPokemonsList();
  Future<Either<Exception, PokemonDto?>> isCaptured({required PokemonDto pokemon});
  Future<Either<Exception, PokemonDto?>> captureOrReleasePokemon({required PokemonDto pokemon});
}

class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final SharedPreferences _sharedPref;

  PokemonLocalDataSourceImpl({required SharedPreferences sharedPreferences}) : _sharedPref = sharedPreferences;

  @override
  Future<bool> savePokemonsList({required List<PokemonDto> pokemonsList}) {
    log('PokemonLocalDataSourceImpl -> savePokemonsList()');
    final pokemonsListToRawJsonList = pokemonsList.map((pokemon) => pokemon.toRawJson()).toList();
    return _sharedPref.setStringList(Constants.pokemonListKey, pokemonsListToRawJsonList);
  }

  @override
  Future<Either<Exception, List<PokemonDto>>> getPokemonsList() {
    log('PokemonLocalDataSourceImpl -> getPokemonsList()');
    List<String>? pokemonsRawJsonList = _sharedPref.getStringList(Constants.pokemonListKey);
    if (pokemonsRawJsonList == null || pokemonsRawJsonList.isEmpty) return Future.value(right([]));
    List<PokemonDto> listOfPokemons = [];
    try {
      listOfPokemons = pokemonsRawJsonList.map((pokemon) => PokemonDto.fromRawJson(pokemon)).toList();
    } on Error catch (_) {
      return Future.value(left(Exception()));
    }
    return Future.value(right(listOfPokemons));
  }

  @override
  Future<bool> savePokemon({required PokemonDto pokemon}) async {
    log('PokemonLocalDataSourceImpl -> savePokemon()');
    try {
      bool saved = await _sharedPref.setString('${pokemon.id}', pokemon.toRawJson());
      return Future.value(saved);
    } catch (_) {
      return Future.value(false);
    }
  }

  @override
  Future<Either<Exception, PokemonDto>> getPokemon({required int id}) async {
    log('PokemonLocalDataSourceImpl -> getPokemon()');
    try {
      String? pokemon = _sharedPref.getString(id.toString());
      if (pokemon == null) return Future.value(left(Exception()));
      return Future.value(right(PokemonDto.fromRawJson(pokemon)));
    } catch (e) {
      return Future.value(left(Exception()));
    }
  }

  @override
  Future<Either<Exception, List<PokemonDto>>> getCapturedPokemonsList() {
    log('PokemonLocalDataSourceImpl -> getCapturedPokemonsList()');
    List<String>? pokemonsRawJsonList = _sharedPref.getStringList(Constants.pokemonCapturedListKey);
    if (pokemonsRawJsonList == null || pokemonsRawJsonList.isEmpty) return Future.value(right([]));
    List<PokemonDto> listOfPokemons = [];
    try {
      listOfPokemons = pokemonsRawJsonList.map((pokemon) => PokemonDto.fromRawJson(pokemon)).toList();
    } on Error catch (_) {
      return Future.value(left(Exception()));
    }
    return Future.value(right(listOfPokemons));
  }

  @override
  Future<Either<Exception, PokemonDto?>> isCaptured({required PokemonDto pokemon}) async {
    log('PokemonLocalDataSourceImpl -> isCaptured()');
        return await getCapturedPokemonsList().then((result) {
      return result.fold(
        (exception) => Future.value(right(null)),
        (pokemons) => Future.value(right(pokemons.where((element) => element.id == pokemon.id).toList().firstOrNull)),
      );
    });
  }

  Future<bool> _updateCapturedPokemonsList(List<PokemonDto> listOfPokemons) {
    log('PokemonLocalDataSourceImpl -> _updateCapturedPokemonsList()');
    final pokemonsListToRawJsonList = listOfPokemons.map((pokemon) => pokemon.toRawJson()).toList();
    return _sharedPref.setStringList(Constants.pokemonCapturedListKey, pokemonsListToRawJsonList);
  }

  @override
  Future<Either<Exception, PokemonDto?>> captureOrReleasePokemon({required PokemonDto pokemon}) async {
    log('PokemonLocalDataSourceImpl -> captureOrReleasePokemon()');
    List<PokemonDto> pokemonsList = await getCapturedPokemonsList().then((result) {
      return result.fold(
        (exception) => [],
        (pokemons) => pokemons,
      );
    });

    if (pokemonsList.isEmpty || pokemonsList.where((element) => element.id == pokemon.id).toList().firstOrNull == null) {
      pokemonsList.add(pokemon);
      _updateCapturedPokemonsList(pokemonsList);
      return Future.value(right(pokemon));
    } else {
      pokemonsList.removeWhere((element) => element.id == pokemon.id);
      _updateCapturedPokemonsList(pokemonsList);
      return Future.value(right(null));
    }
  }
}
