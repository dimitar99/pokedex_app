import 'package:pokedex_app/layers/data/dto/pokemon_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PokemonLocalDataSource {
  /// Pokemons List that comes from api
  Future<bool> savePokemonsList({required List<PokemonDto> pokemonsList});
  Future<List<PokemonDto>> getPokemonsList();

  /// Pokemons List that comes from api
  Future<bool> saveCapturedPokemonsList({required List<PokemonDto> pokemonsList});
  Future<List<PokemonDto>> getCapturedPokemonsList();

  /// Pokemon used for pokemon detail page
  Future<bool> savePokemon({required PokemonDto pokemon});
  Future<PokemonDto> getPokemon({required String id});
}

class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final SharedPreferences _sharedPref;

  PokemonLocalDataSourceImpl({required SharedPreferences sharedPreferences}) : _sharedPref = sharedPreferences;

  @override
  Future<bool> savePokemonsList({required List<PokemonDto> pokemonsList}) {
    // TODO: implement savePokemonsList
    throw UnimplementedError();
  }

  @override
  Future<List<PokemonDto>> getPokemonsList() {
    // TODO: implement getPokemonsList
    throw UnimplementedError();
  }

  @override
  Future<bool> saveCapturedPokemonsList({required List<PokemonDto> pokemonsList}) {
    // TODO: implement saveCapturedPokemonsList
    throw UnimplementedError();
  }

  @override
  Future<List<PokemonDto>> getCapturedPokemonsList() {
    try {
      final List<PokemonDto> listOfPokemon = [];
      return Future.value(listOfPokemon);
    } catch (e) {
      return Future.value([]);
    }
  }

  @override
  Future<bool> savePokemon({required PokemonDto pokemon}) {
    // TODO: implement savePokemon
    throw UnimplementedError();
  }

  @override
  Future<PokemonDto> getPokemon({required String id}) {
    // TODO: implement getPokemon
    throw UnimplementedError();
  }
}
