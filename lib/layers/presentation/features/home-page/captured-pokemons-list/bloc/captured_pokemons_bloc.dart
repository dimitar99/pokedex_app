import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/core/providers/theme_provider/theme_provider.dart';
import 'package:pokedex_app/layers/data/dto/pokemon/pokemon_dto.dart';
import 'package:pokedex_app/layers/domain/use-cases/pokemon/pokemon_usecase.dart';
import 'package:pokedex_app/layers/presentation/shared/constants/constants.dart';
import 'package:pokedex_app/layers/presentation/shared/utils/pokemon_color_by_type.dart';
import 'package:pokedex_app/layers/presentation/shared/utils/theme_by_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'captured_pokemons_event.dart';
part 'captured_pokemons_state.dart';

class CapturedPokemonsBloc extends Bloc<CapturedPokemonsEvent, CapturedPokemonsState> {
  final PokemonUseCase pokemonsUseCase;
  List<PokemonDto> _listOfPokemons = [];
  List<PokemonDto> _filteredPokemonList = [];

  List<PokemonDto> get listOfPokemons => _filteredPokemonList;
  List<String> get pokemonTypes {
    List<String> pokemonTypes = [];
    for (var pokemon in _listOfPokemons) {
      for (var pokemonType in pokemon.types) {
        if (pokemonType.type?.name != null) pokemonTypes.add(pokemonType.type!.name!);
      }
    }
    // Lo pasamos a Set para eliminar los duplicados y luego a list de nuevo
    pokemonTypes = pokemonTypes.toSet().toList();

    // Ordenamos alfabeticamente
    pokemonTypes.sort((a, b) => a.compareTo(b));
    pokemonTypes.insert(0, 'All');
    return pokemonTypes;
  }

  CapturedPokemonsBloc({required this.pokemonsUseCase}) : super(PokemonsInitialState()) {
    on<LoadCapturedPokemonsUseCaseAction>(_loadPokemonsUseCaseAction);
    on<FilterCapturedPokemonsUseCaseAction>(_filterPokemonsUseCaseAction);
  }

  Future _loadPokemonsUseCaseAction(LoadCapturedPokemonsUseCaseAction event, Emitter<CapturedPokemonsState> emit) async {
    emit(PokemonsLoadingState());
    await pokemonsUseCase.callCapturedPokemons().then((result) {
      result.fold(
        (exception) => emit(PokemonsErrorState()),
        (pokemons) {
          _listOfPokemons = List<PokemonDto>.of(pokemons);
          _filteredPokemonList = List<PokemonDto>.of(pokemons);
          // Sort by id by default
          _filteredPokemonList.sort((a, b) => a.id!.compareTo(b.id!));
          _updateTheme(List<PokemonDto>.of(pokemons), event.themeProvider);
          emit(PokemonsLoadedState(listOfPokemons: _listOfPokemons));
        },
      );
    });
  }

  _updateTheme(List<PokemonDto> listOfPokemons, ThemeProvider themeProvider) async {
    // Get all different types
    Map<String, int> typesCount = {};
    for (var pokemon in listOfPokemons) {
      for (var type in pokemon.types) {
        if (type.type?.name != null) typesCount[type.type!.name!] = (typesCount[type.type?.name] ?? 0) + 1;
      }
    }

    log('Pokemon types -> $typesCount');

    // Get the max value of types
    int maxValue = 0;
    for (var value in typesCount.values) {
      if (value > maxValue) maxValue = value;
    }

    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    // If there is a predominant value
    if (typesCount.values.where((element) => element == maxValue).toList().length == 1) {
      String pokemonType = typesCount.entries.where((element) => element.value == maxValue).toList().first.key;
      // Saved last pokemon type used to shared preferences
      await sharedPrefs.setString(Constants.lastPokemonTypeColorKey, pokemonType);
      themeProvider.setTheme(getThemeByColor(getPokemonColorByType(pokemonType)));
    } else {
      await sharedPrefs.setString(Constants.lastPokemonTypeColorKey, '');
      themeProvider.setTheme(getThemeByColor(getPokemonColorByType('')));
    }
  }

  Future _filterPokemonsUseCaseAction(FilterCapturedPokemonsUseCaseAction event, Emitter<CapturedPokemonsState> emit) async {
    if (_listOfPokemons.isEmpty) return;

    _filteredPokemonList = List<PokemonDto>.of(_listOfPokemons);

    // Sort by id by default
    _filteredPokemonList.sort((a, b) => a.id!.compareTo(b.id!));

    // Sort by type
    if (event.type.isNotEmpty && event.type != 'All') {
      _filteredPokemonList = _filteredPokemonList.map((e) => e).where((pokemon) => pokemon.types.any((type) => type.type?.name == event.type)).toList();
    }

    // Sort alphabetically by name
    if (event.alphabetical) {
      _filteredPokemonList.sort((a, b) => a.name.compareTo(b.name));
    } else {
      _filteredPokemonList.sort((a, b) => b.name.compareTo(a.name));
    }

    emit(PokemonsLoadedState(listOfPokemons: _filteredPokemonList));
  }
}
